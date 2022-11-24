import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application_using_bloc/domain_layer/status.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/bloc/task_bloc.dart';

import '../../../domain_layer/task_model.dart';
import '../cubit/TimerCubit/timer_cubit.dart';

class ListTaskWidget extends StatefulWidget {
  const ListTaskWidget({Key? key, required this.task}) : super(key: key);

  final Task task;

  static Widget navigate(BuildContext context, Task task) {
    return BlocProvider(
      create: (context) => TimerCubit(task.time),
      child: ListTaskWidget(
        task: task,
      ),
    );
  }

  @override
  State<ListTaskWidget> createState() => _ListTaskWidgetState();
}

class _ListTaskWidgetState extends State<ListTaskWidget> {
  late TimerCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<TimerCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimerCubit, TimerState>(
      listener: (context, state) {
        if (state is TimerFinished) {
          context
              .read<TaskBloc>()
              .add(UpdateTaskComplete(Status.done, widget.task.id));
        } else if (state is TimerPaused) {
          context.read<TaskBloc>().add(UpdateTaskInProgress(
              Status.inProgress, widget.task.id, state.time));
        }
      },
      child: Card(
        color: widget.task.status == Status.todo
            ? Colors.blue.withOpacity(.2)
            : widget.task.status == Status.done
                ? Colors.green.withOpacity(.2)
                : Colors.yellow.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Visibility(
                      visible: widget.task.description != null,
                      child: Text(
                        widget.task.description ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )),
                  const SizedBox(
                    height: 4,
                  ),
                  BlocBuilder<TimerCubit, TimerState>(
                    builder: (context, state) {
                      if (state is TimerRunning) {
                        final min = state.time.inMinutes.remainder(60);
                        final sec = state.time.inSeconds.remainder(60);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.timer),
                            const SizedBox(
                              width: 2,
                            ),
                            const Text("Duration:"),
                            Text("$min: $sec")
                          ],
                        );
                      } else if (state is TimerPaused) {
                        final min = state.time.inMinutes.remainder(60);
                        final sec = state.time.inSeconds.remainder(60);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.timer),
                            const SizedBox(
                              width: 2,
                            ),
                            Text("Paused:"),
                            Text("$min: $sec")
                          ],
                        );
                      } else if (state is TimerFinished) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.timer),
                            SizedBox(
                              width: 2,
                            ),
                            Text("Finished:"),
                          ],
                        );
                      } else if (state is TimerInitial) {
                        final min = state.time.inMinutes.remainder(60);
                        final sec = state.time.inSeconds.remainder(60);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.timer),
                            const SizedBox(
                              width: 2,
                            ),
                            Text("Duration:"),
                            Text("$min: $sec")
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Chip(
                    backgroundColor: Colors.transparent,
                    label: widget.task.status == Status.done
                        ? Text(Status.done.name.toUpperCase())
                        : Text(context.watch<TimerCubit>().state
                                    is TimerRunning ||
                                context.watch<TimerCubit>().state is TimerPaused
                            ? "In-Progress"
                            : context.watch<TimerCubit>().state is TimerFinished
                                ? "Done"
                                : "TODO"),
                  ),
                ],
              ),
              BlocBuilder<TimerCubit, TimerState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (state is TimerInitial) {
                        _cubit.startTimer();
                      } else if (state is TimerRunning) {
                        _cubit.pauseTimer();
                      } else if (state is TimerPaused) {
                        _cubit.resumeTime();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      state is TimerInitial || state is TimerPaused
                          ? Icons.play_arrow
                          : state is TimerFinished
                              ? Icons.check
                              : Icons.pause,
                      color: Colors.white,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
