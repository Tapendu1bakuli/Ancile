import 'package:ancile/routes/app_pages.dart';
import 'package:ancile/utils/Store/HiveStore.dart';
import 'package:ancile/utils/theme/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'languages/LocalizationService.dart';


void main() async {
  SettingsService settingsService = Get.put(SettingsService());
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStore().initBox();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(GetMaterialApp(
    translations: LocalizationService(),
    supportedLocales: LocalizationService.locales,
    locale: LocalizationService.locale,
    fallbackLocale: LocalizationService.fallbackLocale,
    defaultTransition: Transition.cupertino,
    debugShowCheckedModeBanner: false,
    initialRoute:Theme1AppPages.INITIAL,
    getPages: Theme1AppPages.routes,
     themeMode: settingsService.getThemeMode(),
     theme: settingsService.getLightTheme(),
     darkTheme: settingsService.getDarkTheme(),
  ),
  );
}

