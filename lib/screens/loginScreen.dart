import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:st_01/controller/imagepicker.dart';
import 'package:st_01/controller/user.dart';
class Loginscreen extends StatelessWidget {
  Loginscreen({super.key});
  bool success= false; // Initialize success variable
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final UserController userController = Get.put(UserController());

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      success=await userController.Login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if(success){
        _emailController.clear();
        _passwordController.clear();
      }
    }
  }
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
                Text("Login your accoun"),
                const SizedBox(height: 20),
                SizedBox(height: 20,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                          Obx(() => userController.isLoading.value
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                            onPressed: _submit,
                            child: Text("Login Account"),
                          )),
                          SizedBox(width: 20,),
                          ElevatedButton(
                              onPressed:(){ Get.toNamed('/register');},
                              child: Text("register account")
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

