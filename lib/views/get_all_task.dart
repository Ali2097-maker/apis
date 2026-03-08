import 'package:flutter/material.dart';
import 'package:flutter_models/views/search_task.dart';
import 'package:flutter_models/views/update_task.dart';
import 'package:provider/provider.dart';

import '../ models/Tasklisting.dart';
import '../provider/user_token_provider.dart';
import '../services/task.dart';
import 'create_task.dart';
import 'filter_task.dart';
import 'get_completed.dart';
import 'get_incompleted.dart';
import 'get_profile.dart';

class GetAllTaskView extends StatefulWidget {
  const GetAllTaskView({super.key});

  @override
  State<GetAllTaskView> createState() => _GetAllTaskViewState();
}

class _GetAllTaskViewState extends State<GetAllTaskView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Task"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetCompletedTask()));
          }, icon: Icon(Icons.circle)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetInCompletedTask()));
          }, icon: Icon(Icons.incomplete_circle)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchTask()));
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> FilterTask()));
          }, icon: Icon(Icons.filter)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetProfile()));
          }, icon: Icon(Icons.person)),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateTask()));
        },
        child: Icon(Icons.add),
      ),
      body: FutureProvider.value(
        value: TaskServices().getAllTask(userProvider.getToken().toString()),
        initialData: TaskListingModel(),
        builder: (context, child) {
          TaskListingModel taskListingModel =
          context.watch<TaskListingModel>();
          return taskListingModel.tasks == null
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
              itemCount: taskListingModel.tasks!.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: Icon(Icons.task),
                  title: Text(
                      taskListingModel.tasks![i].description.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(value: taskListingModel.tasks![i].complete  ?? false,
                          onChanged: taskListingModel.tasks![i].complete == true ? null
                              : (val)async{
                            try{
                              setState(() {
                                isLoading = true;
                              });
                              await TaskServices().markTaskAsCompleted(
                                  token: userProvider.getToken().toString(),
                                  taskID: taskListingModel.tasks![i].id.toString())
                                  .then((value){
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("Task Completed Successfully")));
                              });

                            }catch(e){
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(e.toString())));
                            }
                          }),


                      IconButton(
                          onPressed: () async {
                            try {
                              isLoading = true;
                              setState(() {});
                              await TaskServices()
                                  .deleteTask(
                                  token: userProvider
                                      .getToken()
                                      .toString(),
                                  taskID: taskListingModel
                                      .tasks![i].id
                                      .toString())
                                  .then((val) {
                                isLoading = false;
                                setState(() {});
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(
                                        "Task has been deleted successfully")));
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      IconButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateTask(
                                        model:
                                        taskListingModel.tasks![i])));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                );
              });
        },
      ),

    );
  }
}