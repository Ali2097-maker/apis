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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          TextField(controller: emailController,
            decoration: InputDecoration(
              hintText: "Email",
            ),),
          TextField(controller: passwordController,
            decoration: InputDecoration(
              hintText: "Password",
            ),),
          isLoading ? Center(child: CircularProgressIndicator(),)
              :ElevatedButton(
            onPressed: () async {
              try {
                isLoading = true;
                setState(() {});

                var value = await AuthServices().loginUser(
                  email: emailController.text,
                  password: passwordController.text,
                );

                userProvider.setToken(value.token.toString());

                var userData = await AuthServices()
                    .getProfile(token: value.token.toString());

                userProvider.setUser(userData);

                isLoading = false;
                setState(() {});

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("Login Successfully"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GetAllTaskView()));
                          },
                          child: Text("Okay"),
                        )
                      ],
                    );
                  },
                );
              } catch (e) {
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: Text("Login"),
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
          }, child: Text("Register"))
        ],
      ),
    );
  }
}