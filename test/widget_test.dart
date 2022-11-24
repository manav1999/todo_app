// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_application_using_bloc/data_layer/db.dart';
import 'package:todo_application_using_bloc/data_layer/hive_payload.dart';
import 'package:todo_application_using_bloc/domain_layer/error.dart';
import 'package:todo_application_using_bloc/domain_layer/status.dart';
import 'package:todo_application_using_bloc/domain_layer/task_model.dart';

import 'package:todo_application_using_bloc/main.dart';
const TEST_MOCK_STORAGE = './test/fixtures/core';

Future<void> main() async {
  setUp(() async {
    await setUpTestHive();
    Hive.registerAdapter(HivePayloadAdapter());

  });

  tearDown(() async {
    await tearDownTestHive();
  });
  test("Create New Task", () async {
    final db = TaskDb();
    final newTask = Task(id: "qwerty", title: "hello", time: Duration(minutes: 1), status: Status.todo);
    final Either<TaskError, bool> response = await db.addTask(task: newTask);
    response.fold((left) => print(left.message), (right) => null);
    expect(response.isRight, true);
  });

}
