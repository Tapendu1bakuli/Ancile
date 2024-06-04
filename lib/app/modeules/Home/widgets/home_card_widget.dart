import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../device_manager/screen_constants.dart';
import '../../../../utils/TextStyles.dart';
import '../../../../utils/colors/app_colors.dart';
import '../../../../utils/text_utils/app_strings.dart';

class HomeCardWidget extends StatelessWidget {
  HomeCardWidget(
      {super.key,
      this.image,
      this.firstName,
      this.lastName,
        this.age,
        this.value,
      this.onTap,
      });

  String? image;
  String? firstName;
  String? lastName;
  int? age;
  bool? value;
  Function(bool?)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
        NetworkImage(image!),
      ),
      title: Text(
          '$firstName $lastName'),
      subtitle: Text('Age: $age'),
      trailing: Obx(() {
        return Checkbox(
          value: value,
          onChanged: onTap
        );
      }),
    );
  }
}
