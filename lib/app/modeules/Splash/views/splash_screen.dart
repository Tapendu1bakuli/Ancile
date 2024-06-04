import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../device_manager/screen_constants.dart';
import '../../../../utils/TextStyles.dart';
import '../../../../utils/animation_utilis/animation_utilis.dart';
import '../../../../utils/text_utils/app_strings.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.isLoading.value = false;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.welcomeToAncile,
              style: context.textTheme.headlineMedium,
            )
          ],
        ),
      ),
    );
  }
}
