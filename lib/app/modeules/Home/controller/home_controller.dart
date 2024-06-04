
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../database/db_helper.dart';
import '../../../../utils/utils.dart';
import '../../../models/users.dart';
import 'database_service.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin{
  //for controlling the smooth animation while showing the home and drawer.
  late final AnimationController animationController;
  //for toggle between drawer and home UI.
  RxBool toggleValue = false.obs;
  //for fetching all data from db.
  RxList<Map<String, dynamic>> allData = <Map<String, dynamic>>[].obs;
  //for showing circular progress indicator if needed while loading some data .
  RxBool isLoading = false.obs;
  //variables for all the text form fields.
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController titleEditController = TextEditingController();
  final TextEditingController descEditController = TextEditingController();
  //variables for storing the image path and image name after get the image either from gallery or camera.
  RxString temporaryDocImageName = "".obs;
  RxString temporaryDocImagePath = "".obs;
  final DatabaseService _databaseService = DatabaseService();
  var users = <User>[].obs;
  var selectedUsers = <User>[].obs;


@override
  void onInit() {
    super.onInit();
    animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    fetchUsersFromDatabase();
    refreshData();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  //refresh data's after add or update or delete.
  void refreshData() async {
    final data = await SQLHelper.getAllData();
    allData.value = data;
    isLoading.value = false;
  }
  //add data to db
 Future<void> addData(String title, String desc,String image) async {
  await SQLHelper.createData(title, desc,image);
  refreshData();
 }
  //update data to db.
  Future<void> updateData(int id,String title,String description,String image) async {
    await SQLHelper.updateData(id,title, description,image);
    refreshData();
    Get.back();
  }
  //delete data from db.
  Future<void> deleteData(int id) async {
    await SQLHelper.deleteData(id);
    showSuccessSnackbar("Item deleted", "Deletion successful.");
    refreshData();
  }

  final String _baseUrl = 'https://randomuser.me/api';

  Future<void> fetchUsersFromApi(int count) async {
    try {
      List<User> fetchedUsers = await fetchUsers(count);
      for (var user in fetchedUsers) {
        await _databaseService.insertUser(user);
      }
      users.addAll(fetchedUsers);
    } catch (e) {
      print("Failed to fetch users: $e");
    }
  }

  void sortUsers(bool ascending) {
    if (ascending) {
      users.sort((a, b) => a.firstName.compareTo(b.firstName));
    } else {
      users.sort((a, b) => b.firstName.compareTo(a.firstName));
    }
  }

  void showYoungestUsers() {
    users.sort((a, b) => a.age.compareTo(b.age));
    users.value = users.take(2).toList();
  }

  void toggleSelection(User user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
  }

  Future<void> deleteSelectedUsers() async {
    for (var user in selectedUsers) {
      await _databaseService.deleteUser(users.indexOf(user));
      users.remove(user);
    }
    selectedUsers.clear();
  }

  Future<void> fetchUsersFromDatabase() async {
    print("fetchUsersFromDatabase");
    List<User> dbUsers = await _databaseService.getUsers();
    users.addAll(dbUsers);
  }

  Future<List<User>> fetchUsers(int count) async {
    print("fetchUsers");
    final response = await http.get(Uri.parse('$_baseUrl?results=$count'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> results = data['results'];
      print(results);
      isLoading.value = false;
      return results.map((user) => User.fromJson(user)).toList();
    } else {
      isLoading.value = false;
      throw Exception('Failed to load users');
    }
  }


  toggleAnimation() {
    animationController.isDismissed
        ? animationController.forward()
        : animationController.reverse();
  }
}