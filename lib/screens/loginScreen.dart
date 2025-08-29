import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class Loginscreen extends StatelessWidget {
  Loginscreen({super.key});

  bool success = false; // Initialize success variable
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      success = await authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (success) {
        _emailController.clear();
        _passwordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = Color(0xFF0D1B2A); // Dark Blue
    final lightAqua = Color(0xFF7FFFD4); // Light Aqua

    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        title: const Text('Login Screen'),
        backgroundColor: darkBlue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Login your account",
                style: TextStyle(
                  color: lightAqua,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: lightAqua),
                      decoration: InputDecoration(
                        label: Icon(Icons.email, color: lightAqua),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: lightAqua, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: lightAqua, width: 2),
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(color: lightAqua.withOpacity(0.7)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: lightAqua),
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Icon(Icons.lock, color: lightAqua),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: lightAqua, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: lightAqua, width: 2),
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(color: lightAqua.withOpacity(0.7)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                              () => authController.isLoading.value
                              ? CircularProgressIndicator(color: lightAqua)
                              : ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: lightAqua,
                              foregroundColor: darkBlue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Login Account"),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightAqua,
                            foregroundColor: darkBlue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Register Account"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
