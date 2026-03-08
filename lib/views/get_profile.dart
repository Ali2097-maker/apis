import 'package:flutter/material.dart';
import 'package:flutter_models/views/update_profile.dart';
import 'package:provider/provider.dart';

import '../provider/user_token_provider.dart';

class GetProfile extends StatelessWidget {
  const GetProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Text("Name: ${userProvider.getUser()?.user?.name.toString()}"),
          Text("Email: ${userProvider.getUser()?.user?.email.toString()}"),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProfileView()));
          }, child: Text("Update Profile"))
        ],
      ),
    );
  }
}