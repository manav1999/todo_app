part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final String title;
  final String? desc;
  final Duration duration;

  CreateTaskEvent({required this.title, this.desc, required this.duration});
}

class GetAllTaskEvent extends TaskEvent {

  GetAllTaskEvent();
}

class UpdateTaskComplete extends TaskEvent {
  final Status taskStatus;
  final String id;

  UpdateTaskComplete(this.taskStatus, this.id);
}

class DeleteTask extends TaskEvent {
  final String id;

  DeleteTask(this.id);
}


class UpdateTaskInProgress extends TaskEvent {
  final Status taskStatus;
  final String id;
  final Duration time;

  UpdateTaskInProgress(this.taskStatus, this.id, this.time);
}


