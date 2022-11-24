import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:meta/meta.dart';
import 'package:todo_application_using_bloc/domain_layer/status.dart';
import 'package:uuid/uuid.dart';

import '../../../data_layer/db.dart';
import '../../../domain_layer/error.dart';
import '../../../domain_layer/task_model.dart';

part 'task_event.dart';

part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskDb db;
  List<Task> task = [];
  final Uuid uid = Uuid();

  TaskBloc(this.db) : super(TaskInitial()) {
    on<GetAllTaskEvent>((event, emit) async {
      emit(LoadingTaskState());
      final Either<TaskError, List<Task>> response = await db.getAllTask();
      response.fold(
          (left) =>
              emit(ErrorTaskState(left.message ?? "SOMETHING WENT WRONG")),
          (right) {
        task = right;
        if (task.isEmpty) {
          emit(EmptyTaskState());
        } else {
          emit(SuccessTaskState(task));
        }
      });
    });

    on<CreateTaskEvent>((event, emit) async {
      final newTask = Task(
          id: uid.v1(),
          title: event.title,
          time: event.duration,
          description: event.desc,
          status: Status.todo);
      final Either<TaskError, bool> response = await db.addTask(task: newTask);
      response.fold(
          (left) =>
              emit(ErrorTaskState(left.message ?? "SOMETHING WENT WRONG")),
          (right) {
        task.add(newTask);
        if (task.isEmpty) {
          emit(EmptyTaskState());
        } else {
          emit(SuccessTaskState(task));
        }
      });
    });

    on<UpdateTaskInProgress>((event, emit) async {
      final currentTask = task
          .firstWhere((element) => element.id == event.id)
          .copyWith(
              isPausedNow: true,
              updatedStatus: event.taskStatus,
              remainingTime: event.time);
      final Either<TaskError, bool> response =
          await db.addTask(task: currentTask);
      response.fold(
          (left) =>
              emit(ErrorTaskState(left.message ?? "SOMETHING WENT WRONG")),
          (right) {
        final index = task.indexWhere((element) => element.id == event.id);
        task.removeAt(index);
        task.insert(index,currentTask);
        if (task.isEmpty) {
          emit(EmptyTaskState());
        } else {
          emit(SuccessTaskState(task));
        }
      });
    });

    on<UpdateTaskComplete>((event, emit) async {
      final currentTask =
          task.firstWhere((element) => element.id == event.id).copyWith(
                isPausedNow: true,
                updatedStatus: event.taskStatus,
              );
      final Either<TaskError, bool> response =
          await db.addTask(task: currentTask);
      response.fold(
          (left) =>
              emit(ErrorTaskState(left.message ?? "SOMETHING WENT WRONG")),
          (right) {
        task.removeWhere((element) => element.id == event.id);
        task.add(currentTask);
        if (task.isEmpty) {
          emit(EmptyTaskState());
        } else {
          emit(SuccessTaskState(task));
        }
      });
    });

    on<DeleteTask>((event, emit) async {
      final Either<TaskError, bool> response =
          await db.deleteTask(id: event.id);
      response.fold(
          (left) =>
              emit(ErrorTaskState(left.message ?? "SOMETHING WENT WRONG")),
          (right) {
        task.removeWhere((element) => element.id == event.id);
        if (task.isEmpty) {
          emit(EmptyTaskState());
        } else {
          emit(SuccessTaskState(task));
        }
      });
    });
  }
}
