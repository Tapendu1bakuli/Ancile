import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/universal_button_widget.dart';
import '../../../../device_manager/screen_constants.dart';
import '../../../../utils/TextStyles.dart';
import '../../../../utils/colors/app_colors.dart';
import '../../../../utils/text_utils/app_strings.dart';
import '../../../../utils/utils.dart';
import '../../../models/users.dart';
import '../controller/home_controller.dart';
import 'drawer_data_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rightSlide = MediaQuery.of(context).size.width * 0.6;
    Uint8List bytes;
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                double slide =
                    rightSlide * controller.animationController.value +
                        ScreenConstant.defaultHeightFifteen;
                double scale =
                    1.1 - (controller.animationController.value * 0.3);
                return Stack(
                  children: [
                    const Scaffold(
                      backgroundColor: CustomColor.primaryBlue,
                      body: DrawerDataScreen(),
                    ),
                    Transform(
                      transform: Matrix4.identity()
                        ..translate(slide)
                        ..scale(scale),
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.only(
                            right: ScreenConstant.defaultWidthThirty),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: CustomColor.secondaryBlue,
                              spreadRadius: 30,
                              blurRadius: 50,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Scaffold(
                            body: ListView(
                          children: [
                            Container(
                              height: ScreenConstant.defaultHeightThirty,
                            ),
                            AppBar(
                              scrolledUnderElevation: 0.0,
                              title: Text(
                                AppStrings.welcomeToAncile,
                                style:
                                    TextStyles.carousalSubTitleWidgetBlueText,
                              ),
                              centerTitle: false,
                              leading: Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenConstant.defaultWidthTen),
                                child: IconButton(
                                  onPressed: () => controller.toggleAnimation(),
                                  icon: AnimatedIcon(
                                    icon: AnimatedIcons.menu_close,
                                    color: CustomColor.white,
                                    progress: controller.animationController,
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => AppBar(
                                  title: Text(AppStrings.randomList.tr,
                                      style: TextStyles
                                          .carousalSubTitleWidgetBlueText
                                          .copyWith(fontSize: 15)),
                                  actions: [
                                    IconButton(
                                      icon: const Icon(Icons.sort_by_alpha,
                                          color: CustomColor.white),
                                      onPressed: () {
                                        controller.sortUsers(true);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.sort,
                                          color: CustomColor.white),
                                      onPressed: () {
                                        controller.sortUsers(false);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.person_search,
                                          color: CustomColor.white),
                                      onPressed: () {
                                        controller.showYoungestUsers();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                      ),
                                      onPressed: controller
                                              .selectedUsers.isNotEmpty
                                          ? () {
                                              controller.deleteSelectedUsers();
                                            }
                                          : null,
                                    ),
                                  ]),
                            ),
                            Container(
                              height: ScreenConstant.defaultHeightTen,
                            ),
                            Container(
                              height: ScreenConstant.defaultHeightTen,
                            ),
                            Obx(
                              () => controller.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : UniversalButtonWidget(
                                      ontap: () async {
                                        controller.isLoading.value = true;
                                        try {
                                          final result =
                                              await InternetAddress.lookup(
                                                  AppStrings.google);
                                          if (result.isNotEmpty &&
                                              result[0].rawAddress.isNotEmpty) {
                                            controller.fetchUsersFromApi(10);
                                          } else {
                                            showFailureSnackBar(AppStrings.error.tr,
                                                AppStrings.error.tr);
                                            controller.isLoading.value = false;
                                          }
                                        } on SocketException catch (_) {
                                          showFailureSnackBar(AppStrings.error.tr,
                                              AppStrings.error.tr);
                                          controller.isLoading.value = false;
                                        }
                                      },
                                      color: Get.theme.dividerColor,
                                      margin: EdgeInsets.symmetric(
                                        vertical:
                                            ScreenConstant.defaultHeightFifteen,
                                        horizontal:
                                            ScreenConstant.defaultWidthTwenty,
                                      ),
                                      leadingIconvisible: true,
                                      title: AppStrings.addVlog.tr,
                                      titleTextStyle: TextStyles
                                          .textStyleRegular
                                          .apply(color: CustomColor.white),
                                    ),
                            ),
                            Container(
                              height: ScreenConstant.defaultHeightTen,
                            ),
                            Obx(
                              () => controller.users.isEmpty
                                  ? const Center(
                                      child: Text(AppStrings.vlogsListIsEmpty))
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ScreenConstant
                                              .defaultWidthTwenty),
                                      child: ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.users.length,
                                        itemBuilder: (context, index) {
                                          User user = controller.users[index];
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(user.picture),
                                            ),
                                            title: Text(
                                                '${user.firstName} ${user.lastName}'),
                                            subtitle: Text('${AppStrings.age}: ${user.age}'),
                                            trailing: Obx(() {
                                              return Checkbox(
                                                value: controller.selectedUsers
                                                    .contains(user),
                                                onChanged: (value) {
                                                  controller
                                                      .toggleSelection(user);
                                                },
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                            Container(
                              height: ScreenConstant.defaultHeightForty,
                            )
                          ],
                        )),
                      ),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }
}
