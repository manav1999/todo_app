part of 'task_bloc.dart';

@immutable
abstract class TaskState {}

class TaskInitial extends TaskState {}


class ErrorTaskState extends TaskState {
  final String error;

  ErrorTaskState(this.error);
}


class SuccessTaskState extends TaskState {
  final List<Task> task;

  SuccessTaskState(this.task);
}

class EmptyTaskState extends TaskState {

}

class LoadingTaskState extends TaskState {}