import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/services/bloc_observer.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/core/utils/theme_manager.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/splash_screen.dart';

void main() {
  Bloc.observer = TarsheedBlocObserver();
  runApp(
      BlocProvider(create: (context) => AuthBloc.instance, child: Tarsheed()));
}

class Tarsheed extends StatelessWidget {
  const Tarsheed({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, child) {
          return BlocProvider(
            create: (context) => SettingsCubit.getInstance,
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: LocalizationManager.getAppTitle(),
                locale: LocalizationManager.getCurrentLocale(),
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                theme: ThemeManager.appTheme(),
                home: SplashScreen()),
          );
        });
  }
}
