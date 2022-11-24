import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/bloc/task_bloc.dart';

import '../../../domain_layer/status.dart';
import '../../../domain_layer/task_model.dart';
import '../cubit/TimerCubit/timer_cubit.dart';

class GridTaskWidget extends StatefulWidget {
  const GridTaskWidget({Key? key, required this.task}) : super(key: key);
  final Task task;

  static Widget navigate(BuildContext context, Task task) {
    return BlocProvider(
      create: (context) => TimerCubit(task.time),
      child: GridTaskWidget(
        task: task,
      ),
    );
  }

  @override
  State<GridTaskWidget> createState() => _GridTaskWidgetState();
}

class _GridTaskWidgetState extends State<GridTaskWidget> {
  late FlipCardController _controller;
  late TimerCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<TimerCubit>();
    _controller = FlipCardController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
        flipOnTouch: false,
        controller: _controller,
        front: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.task.status == Status.todo
                    ? Colors.blue.withOpacity(.2)
                    : widget.task.status == Status.done
                        ? Colors.green.withOpacity(.2)
                        : Colors.yellow.withOpacity(0.2)),
            padding: const EdgeInsets.fromLTRB(4, 2, 2, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.task.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(
                  height: 1,
                ),
                Visibility(
                  visible: widget.task.description != null,
                  child: Text(
                    widget.task.description ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.timer),
                    Text(
                        "${widget.task.time.inMinutes.remainder(60)}: ${widget.task.time.inSeconds.remainder(60)}"),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                        child: Chip(
                            label: Text(widget.task.status.name
                                .toString()
                                .toUpperCase())))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            context
                                .read<TaskBloc>()
                                .add(DeleteTask(widget.task.id));
                          },
                          child: const Icon(Icons.delete)),
                    ),
                    Visibility(
                      visible: widget.task.status != Status.done,
                      child: Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              context.read<TaskBloc>().add(UpdateTaskComplete(
                                  Status.done, widget.task.id));
                            },
                            child: const Icon(Icons.check)),
                      ),
                    )
                  ],
                ),
                Center(
                  child: SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () {
                        _cubit.startTimer();
                        _controller.toggleCard();
                      },
                      child: const Text(
                        "Start Timer",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        back: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: context.watch<TimerCubit>().state is TimerRunning?Colors.yellow.withOpacity(0.2)
                      : widget.task.status == Status.todo
                      ? Colors.blue.withOpacity(.2)
                      : widget.task.status == Status.done
                          ? Colors.green.withOpacity(.2)
                          : Colors.yellow.withOpacity(0.2)),
              padding: const EdgeInsets.fromLTRB(4, 2, 2, 0),
              child: BlocConsumer<TimerCubit, TimerState>(
                listener: (context, state) {
                  if (state is TimerFinished) {
                    _controller.toggleCard();
                    context
                        .read<TaskBloc>()
                        .add(UpdateTaskComplete(Status.done, widget.task.id));
                  } else if (state is TimerPaused) {
                    _controller.toggleCard();
                    context.read<TaskBloc>().add(UpdateTaskInProgress(
                        Status.inProgress, widget.task.id, state.time));
                  }
                },
                builder: (context, state) {
                  if (state is TimerRunning) {
                    final min = state.time.inMinutes.remainder(60);
                    final sec = state.time.inSeconds.remainder(60);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Text('$min: $sec',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 36)),
                        ),
                        Center(
                          child: OutlinedButton(
                            onPressed: () {
                              _cubit.pauseTimer();
                            },
                            child: Text(
                              "Pause Timer",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    );
                  }

                  return SizedBox.shrink();
                },
              )),
        ));
  }
}
