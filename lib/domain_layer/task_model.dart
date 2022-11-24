import 'package:todo_application_using_bloc/domain_layer/status.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final Duration time;
  final Status status;
  final bool isPaused;

  Task(
      {required this.id,
      required this.title,
      this.description,
      required this.time,
      required this.status,
      this.isPaused = false,
      });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        title: json['title'],
        time: Duration(minutes: json['time']),
        status: Status.fromValue(json['status']),
        isPaused: json['is_paused'],
        description: json['desc']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'time': time.inMinutes,
        'status': status.status,
        'is_paused': isPaused,
        'desc': description,

      };

  Task copyWith(
      {bool? isPausedNow, Status? updatedStatus, Duration? remainingTime}) {
    return Task(
        id: id,
        title: title,
        time: remainingTime??time,
        status: updatedStatus ?? status,
        isPaused: isPausedNow ?? isPaused,
        );
  }
}
