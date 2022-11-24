import 'package:flutter/material.dart';
import 'package:todo_application_using_bloc/data_layer/db.dart';
import 'package:todo_application_using_bloc/user_interface_layer/taskApp.dart';

void main() async {
  //initialize database for internal storage
  await TaskDb.initDb();
  //run App
  runApp(const TaskApp());
}
