import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_application_using_bloc/data_layer/hive_payload.dart';
import 'package:todo_application_using_bloc/domain_layer/error.dart';
import 'package:todo_application_using_bloc/domain_layer/task_model.dart';

class TaskDb {
  static Future<void> initDb() async {
    debugPrint("INIT HIVE");
    await Hive.initFlutter();
    Hive.registerAdapter(HivePayloadAdapter());
  }

  static Future<void> closeDb() async {
    debugPrint("HIVE CLOSE");
    await Hive.close();
  }

  Future<Either<TaskError, bool>> addTask({required Task task}) async {
    try {
      final box = await Hive.openBox<HivePayload>('task');
      final payload = HivePayload.create(json: task.toJson(), id: task.id);
      await box.put(task.id, payload);
      box.close();
      return const Right(true);
    } catch (e) {
      return Left(TaskError(message: e.toString()));
    }
  }

  Future<Either<TaskError, bool>> deleteTask({required String id}) async {
    try {
      final box = await Hive.openBox<HivePayload>('task');
      await box.delete(id);
      await box.close();
      return const Right(true);
    } catch (e) {
      return Left(TaskError(message: e.toString()));
    }
  }

  Future<Either<TaskError, List<Task>>> getAllTask() async {
    try {
      List<Task> tasks = [];
      final box = await Hive.openBox<HivePayload>('task');
      //time

      final taskList =
          box.values.map((e) => Task.fromJson(jsonDecode(e.data))).toList();
      if (taskList.isNotEmpty) tasks = taskList;
      await box.close();
      return Right(tasks);
    } catch (e) {
      return Left(TaskError(message: e.toString()));
    }
  }
}
