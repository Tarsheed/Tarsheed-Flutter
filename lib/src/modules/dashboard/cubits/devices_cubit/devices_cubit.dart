import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_creation_form.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/devices/devices_repository.dart';

part 'devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit() : super(DevicesInitial());

  final _repository = sl<DevicesRepository>();

  // Simplified singleton pattern - always return the same instance
  static DevicesCubit get() {
    if (!sl.isRegistered<DevicesCubit>()) {
      sl.registerLazySingleton<DevicesCubit>(() => DevicesCubit());
    }
    return sl<DevicesCubit>();
  }

  @override
  Future<void> close() async {
    _repository.clearData();
    // return super.close();
  }

  Future<void> getDevices({bool refresh = false}) async {
    final currentState = state;
    emit(GetDevicesLoading(
        devices: currentState.devices,
        filterType: currentState.filterType,
        sortOrder: currentState.sortOrder,
        refresh: refresh));

    final result = await _repository.getDevices(reFetch: refresh);
    result.fold(
      (err) {
        emit(GetDevicesError(
          err,
          devices: currentState.devices,
          filterType: currentState.filterType,
          sortOrder: currentState.sortOrder,
        ));
      },
      (devices) => emit(GetDevicesSuccess(
        devices: devices,
        filterType: currentState.filterType,
        sortOrder: currentState.sortOrder,
      )),
    );
  }

  Future<void> addDevice(DeviceCreationForm form) async {
    final currentState = state;
    final current = currentState.devices ?? <Device>[];

    emit(AddDeviceLoading(
      devices: current,
      filterType: currentState.filterType,
      sortOrder: currentState.sortOrder,
    ));

    final result = await _repository.addDevice(form);
    result.fold(
      (err) => emit(AddDeviceError(
        err,
        devices: current,
        filterType: currentState.filterType,
        sortOrder: currentState.sortOrder,
      )),
      (newDevice) {
        final updated = List<Device>.from(current)..add(newDevice);
        emit(AddDeviceSuccess(
          newDevice,
          devices: updated,
          filterType: currentState.filterType,
          sortOrder: currentState.sortOrder,
        ));
      },
    );
  }

  Future<void> editDevice({
    required String id,
    String? name,
    String? description,
    int? pinNumber,
  }) async {
    final currentState = state;
    final current = currentState.devices ?? <Device>[];

    emit(EditDeviceLoading(
      devices: current,
      filterType: currentState.filterType,
      sortOrder: currentState.sortOrder,
    ));

    final result = await _repository.editDevice(
      id: id,
      name: name,
      description: description,
      pinNumber: pinNumber,
    );

    result.fold(
      (err) => emit(EditDeviceError(
        err,
        devices: current,
        filterType: currentState.filterType,
        sortOrder: currentState.sortOrder,
      )),
      (_) {
        final updated = current.map((d) {
          return d.id == id
              ? d.copyWith(
                  name: name ?? d.name,
                  description: description ?? d.description,
                  pinNumber: pinNumber ?? d.pinNumber,
                )
              : d;
        }).toList();
        emit(EditDeviceSuccess(
          devices: updated,
          filterType: currentState.filterType,
          sortOrder: currentState.sortOrder,
        ));
      },
    );
  }

  Future<void> deleteDevice(String id) async {
    final currentState = state;
    final current = currentState.devices ?? <Device>[];

    emit(DeleteDeviceLoading(
      devices: current,
      filterType: currentState.filterType,
      sortOrder: currentState.sortOrder,
    ));

    final result = await _repository.deleteDevice(id);
    result.fold(
      (err) => emit(DeleteDeviceError(
        err,
        devices: current,
        filterType: currentState.filterType,
        sortOrder: currentState.sortOrder,
      )),
      (_) {
        final updated = current.where((d) => d.id != id).toList();
        emit(DeleteDeviceSuccess(
          id,
          devices: updated,
          filterType: currentState.filterType,
          sortOrder: currentState.sortOrder,
        ));
      },
    );
  }

  Future<void> toggleDeviceStatus(String id) async {
    final currentState = state;
    final current = currentState.devices ?? <Device>[];
    final deviceIndex = current.indexWhere((d) => d.id == id);

    if (deviceIndex == -1) return; // Device not found

    final device = current[deviceIndex];
    final optimisticState = !device.state;

    // Update the device in the list optimistically
    final optimisticDevices = List<Device>.from(current);
    optimisticDevices[deviceIndex] = device.copyWith(state: optimisticState);

    emit(ToggleDeviceStatusLoading(
      deviceId: id,
      deviceState: optimisticState,
      devices: optimisticDevices,
      filterType: currentState.filterType,
      sortOrder: currentState.sortOrder,
    ));

    final result = await _repository.toggleDeviceStatus(id);
    result.fold(
      (err) {
        // Revert to the original state on error
        emit(ToggleDeviceStatusError(
          deviceState: device.state,
          err,
          devices: current, // Revert to original list
          deviceId: id,
          filterType: currentState.filterType,
          sortOrder: currentState.sortOrder,
        ));
      },
      (_) {
        // Confirm the optimistic update on success
        emit(ToggleDeviceStatusSuccess(
          deviceState: optimisticState,
          id,
          devices: optimisticDevices, // Keep the updated list
          filterType: currentState.filterType,
          sortOrder: currentState.sortOrder,
        ));
      },
    );
  }

  void updateFilterType(DeviceFilterType filterType) {
    final currentState = state;
    emit(FilterDevicesState(
      devices: currentState.devices,
      filterType: filterType,
      sortOrder: currentState.sortOrder,
    ));
  }

  void toggleSortOrder() {
    final currentState = state;
    final newOrder = currentState.sortOrder == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;

    emit(FilterDevicesState(
      devices: currentState.devices,
      filterType: currentState.filterType,
      sortOrder: newOrder,
    ));
  }

  dynamic getFilteredDevices(List<Room> rooms) {
    final currentState = state;
    final devices = currentState.devices ?? [];

    switch (currentState.filterType) {
      case DeviceFilterType.consumption:
        final sortedDevices = List<Device>.from(devices);
        sortedDevices.sort((a, b) {
          final comparison = a.consumption.compareTo(b.consumption);
          return currentState.sortOrder == SortOrder.ascending
              ? comparison
              : -comparison;
        });
        return sortedDevices;

      case DeviceFilterType.rooms:
        final devicesByRoom = <String, List<Device>>{};

        for (final device in devices) {
          if (!devicesByRoom.containsKey(device.roomId)) {
            devicesByRoom[device.roomId] = [];
          }
          devicesByRoom[device.roomId]!.add(device);
        }

        devicesByRoom.forEach((roomId, roomDevices) {
          roomDevices.sort((a, b) {
            final comparison = a.name.compareTo(b.name);
            return currentState.sortOrder == SortOrder.ascending
                ? comparison
                : -comparison;
          });
        });

        return devicesByRoom;

      case DeviceFilterType.priority:
        final sortedDevices = List<Device>.from(devices);
        sortedDevices.sort((a, b) {
          final comparison = a.priority.compareTo(b.priority);
          return currentState.sortOrder == SortOrder.ascending
              ? comparison
              : -comparison;
        });
        return sortedDevices;
    }
  }
}
