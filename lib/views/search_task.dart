import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ models/Tasklisting.dart';
import '../provider/user_token_provider.dart';
import '../services/task.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({super.key});

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  TaskListingModel? taskListingModel;
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);
    return Scaffold(
      appBar:AppBar(
        title: Text("Search Task"),
      ),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search Task",
            ),
            onChanged: (value)async{
              try{
                setState(() {
                  isLoading = true;
                  taskListingModel = null;
                });
                await TaskServices().searchTask(
                    token: userProvider.getToken().toString(),
                    searchTask: searchController.text)
                    .then((val){
                  setState(() {
                    isLoading = true;
                    taskListingModel = val;
                  });
                });
              }catch(e){
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          ),
          if(isLoading == true)
            Center(child: CircularProgressIndicator(),),
          if(taskListingModel == null)
            Center(child: Text("No Data Found"),)
          else
            Expanded(child: ListView.builder(itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel!.tasks![index].description.toString()),
              );
            },))
        ],
      ),
    );
  }
}