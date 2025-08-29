import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:st_01/controller/auth_controller.dart';
import 'package:st_01/controller/imagepicker.dart';
import 'package:st_01/controller/auth_controller.dart';
import '../controller/user.dart';
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  bool success= false; // Initialize success variable
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());
  final ImagepickerController picker =Get.put(ImagepickerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Register New accoun"),
              const SizedBox(height: 20),
              Stack(
                children: [
                  GetBuilder<ImagepickerController>(
                    builder: (ImagepickerController) {
                      return CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade200,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:picker.fileImage != null
                              ? FileImage(picker.fileImage!)
                              : const AssetImage('assets/images/avatar.png') as ImageProvider,
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    },
                  ),
                  Positioned(
                      bottom: 0,
                      right: -10,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () {
                          picker.Image();
                        },
                      )),
                ],
              ),
              SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        label: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.blueAccent.shade400, width: 1),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1),
                        ),
                      ),

                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        label: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1),
                        ),
                      ),
                    ), SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authController.register(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                image: picker.fileImage!,
                              );
                            }
                          },
                          child: Text("Create Account"),
                        ),
                      ],
                    ),
                  ],
                ),

              )

            ],
          ),
        ),
      ),
    );
  }
}
