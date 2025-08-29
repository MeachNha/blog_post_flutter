import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:st_01/controller/auth_controller.dart';
class Settingscreen extends StatelessWidget {
  Settingscreen({super.key});
  final AuthController authController= Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Text("This is settings page"),
      ),
      drawer: Drawer(
        child: ListTile(
          title: Text("Logout"),
          onTap: () {
            // Add your logout logic here
            authController.logout(); // Close the drawer
          },
        ),
      ),
    );
  }
}
