import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application_using_bloc/data_layer/db.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/bloc/task_bloc.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/cubit/view_toggle_cubit.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/screens/task_home_page.dart';

class TaskApp extends StatelessWidget {
  const TaskApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => TaskBloc(TaskDb()),
      ),
      BlocProvider(
        create: (context) => ViewToggleCubit(),
      )
    ], child:  const MaterialApp(home: TaskHomePage()));
  }
}
