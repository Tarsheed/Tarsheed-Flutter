import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../data/models/device.dart';
import '../../data/models/room.dart';
import '../widgets/card_devices.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/devices_filter_tabs.dart';
import '../widgets/edit_device_dialog.dart';
import 'device_creation_page.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  late final DevicesCubit _devicesCubit;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _devicesCubit = sl<DevicesCubit>();

    // Only fetch devices if they haven't been loaded yet
    if (_devicesCubit.state is DevicesInitial) {
      _devicesCubit.getDevices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DevicesCubit>.value(
      value: _devicesCubit,
      child: const _DevicesScreenContent(),
    );
  }
}

class _DevicesScreenContent extends StatelessWidget {
  const _DevicesScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      extendBody: true,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DevicesCubit>().getDevices(refresh: true);
        },
        child: Stack(
          children: [
            const Positioned.fill(child: BackGroundRectangle()),
            SingleChildScrollView(
              child: Column(
                spacing: 20.h,
                children: [
                  CustomAppBar(text: 'Devices'),
                  DeviceFilterHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: DevicesListView(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AddDeviceScreen());
        },
        backgroundColor: ColorManager.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DeviceFilterHeader extends StatelessWidget {
  const DeviceFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevicesCubit, DevicesState, Map<String, dynamic>>(
      selector: (state) => {
        'filterType': state.filterType,
        'sortOrder': state.sortOrder,
      },
      builder: (context, data) {
        final filterType = data['filterType'] as DeviceFilterType;
        final sortOrder = data['sortOrder'] as SortOrder;

        return Row(
          children: [
            Expanded(
              child: FilterTabsRow(
                selectedTabIndex: filterType.index,
                onTabSelected: (index) {
                  context
                      .read<DevicesCubit>()
                      .updateFilterType(DeviceFilterType.values[index]);
                },
              ),
            ),
            // Sort Order Toggle Button
            IconButton(
              onPressed: () {
                context.read<DevicesCubit>().toggleSortOrder();
              },
              icon: Icon(
                sortOrder == SortOrder.ascending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: ColorManager.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class DevicesListView extends StatelessWidget {
  const DevicesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DevicesCubit, DevicesState>(
      listenWhen: (previous, current) =>
          current is DeleteDeviceSuccess || current is DeleteDeviceError,
      listener: (context, state) {
        if (state is DeleteDeviceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Device deleted successfully')),
          );
        } else if (state is DeleteDeviceError) {
          ExceptionManager.showMessage(state.exception);
        }
      },
      buildWhen: (previous, current) {
        // Only rebuild when the device list changes or loading state changes
        if (current is GetDevicesLoading && current.refresh == true) {
          return true;
        }
        return previous.devices != current.devices ||
            previous.filterType != current.filterType ||
            previous.sortOrder != current.sortOrder ||
            (current is GetDevicesLoading && previous is! GetDevicesLoading) ||
            (previous is GetDevicesLoading && current is! GetDevicesLoading);
      },
      builder: (context, state) {
        // Show loading indicator only for initial load or refresh
        if (state is GetDevicesLoading &&
            (state.devices == null || state.refresh == true)) {
          return Center(
            child: CustomLoadingWidget(),
          );
        }

        if (state is GetDevicesError && state.devices == null) {
          return CustomErrorWidget(
            message: ExceptionManager.getMessage(state.exception),
          );
        }

        final devices = state.devices;
        if (devices == null || devices.isEmpty) {
          return NoDataWidget();
        }

        final rooms = sl<DashboardBloc>().rooms;
        final filteredData =
            context.read<DevicesCubit>().getFilteredDevices(rooms);

        if (state.filterType == DeviceFilterType.rooms) {
          final devicesByRoom = filteredData as Map<String, List<Device>>;
          return _buildRoomsView(devicesByRoom, context, rooms);
        } else {
          final devicesList = filteredData as List<Device>;
          return _buildGridView(devicesList);
        }
      },
    );
  }

  Widget _buildGridView(List<Device> devices) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: devices.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final device = devices[index];
        return Padding(
          padding: EdgeInsets.all(5.w),
          child: DeviceCardWrapper(
            key: ValueKey(devices[index].id),
            device: devices[index],
          ),
        );
      },
    );
  }

  Widget _buildRoomsView(Map<String, List<Device>> devicesByRoom,
      BuildContext context, List<Room> rooms) {
    return ListView.builder(
      itemCount: devicesByRoom.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final roomId = devicesByRoom.keys.toList()[index];
        final roomDevices = devicesByRoom[roomId]!;
        final roomName = _getRoomName(roomId, rooms);
        return Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roomName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              _buildGridView(roomDevices),
            ],
          ),
        );
      },
    );
  }

  String _getRoomName(String roomId, List<Room> rooms) {
    final room = rooms.firstWhere(
      (room) => room.id == roomId,
      orElse: () => Room.empty,
    );
    return room.name;
  }
}

class DeviceCardWrapper extends StatelessWidget {
  final Device device;

  const DeviceCardWrapper({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showDeleteConfirmation(context, device.id),
      child: DeviceCard(
        device: device,
        onToggle: (bool newState) {
          // Handle toggle action
        },
        onEdit: () => _showEditDialog(context, device),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (context) => EditDeviceDialog(device: device),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String deviceId) {
    showDialog(
      context: context,
      builder: (_) => DeleteDeviceDialog(deviceId: deviceId),
    );
  }
}
