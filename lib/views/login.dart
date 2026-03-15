import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_token_provider.dart';
import '../services/auth.dart';
import 'Register.dart';
import 'get_all_task.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void login() async {

    var userProvider = Provider.of<UserTokenProvider>(context, listen: false);

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showMessage("Please fill all fields");
      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      var value = await AuthServices().loginUser(
        email: emailController.text,
        password: passwordController.text,
      );

      userProvider.setToken(value.token.toString());

      var userData =
      await AuthServices().getProfile(token: value.token.toString());

      userProvider.setUser(userData);

      setState(() {
        isLoading = false;
      });

      showMessage("Login Successfully", true);

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      showMessage(e.toString());
    }
  }

  void showMessage(String msg, [bool success = false]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Message"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {

              Navigator.pop(context);

              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GetAllTaskView(),
                  ),
                );
              }

            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/rrk.jpg"),
            fit: BoxFit.cover,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  filled: true,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  filled: true,
                ),
              ),

              const SizedBox(height: 30),

              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: login,
                child: const Text("Login"),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Register(),
                    ),
                  );
                },
                child: const Text("Register"),
              )

            ],
          ),
        ),
      ),
    );
  }
}