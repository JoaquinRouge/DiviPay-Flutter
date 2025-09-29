import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.white, // Fondo general blanco para profesional
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", width: 120),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.only(right: 16, left: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(color: primaryColor),
                          prefixIcon: Icon(Icons.person, color: primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: showPassword,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: primaryColor),
                          prefixIcon: Icon(Icons.lock, color: primaryColor),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: showPassword
                                ? Icon(Icons.visibility, color: primaryColor)
                                : Icon(
                                    Icons.visibility_off,
                                    color: primaryColor,
                                  ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (usernameController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text('Please fill all fields'),
                                  ),
                                );
                            } else {
                              context.go("/home");
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿New to Divipay?"),
                  TextButton(
                    onPressed: () {
                      context.push("/register");
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
