import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/bloc/task_bloc.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/cubit/view_toggle_cubit.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/widgets/create_task_bottomSheet.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/widgets/listTaskWidget.dart';

import '../../../domain_layer/status.dart';
import '../widgets/gridTaskWidget.dart';

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({Key? key}) : super(key: key);

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  late ViewToggleCubit _toggleCubit;
  late TaskBloc _taskBloc;

  @override
  void initState() {
    _toggleCubit = context.read<ViewToggleCubit>();
    _taskBloc = context.read<TaskBloc>();
    _taskBloc.add(GetAllTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
        CreateTaskBottomSheet.showBottomSheet(context);
        },
      ),
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () {
                _toggleCubit.toggleView();
              },
            child: Row(
              children: const [
                Text("Toggle View"),
                Icon(Icons.view_agenda),
                SizedBox(width: 10,)
              ],
            ),
          )
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is ErrorTaskState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is SuccessTaskState) {
            return BlocBuilder<ViewToggleCubit, ViewToggleState>(
              builder: (context, viewState) {
                if (viewState is GridViewState) {
                  return GridView.builder(itemCount: state.task.length,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context,index){
                    return GridTaskWidget.navigate(context,state.task[index]);
                  });
                } else if (viewState is ListViewState) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Dismissible(
                          background: Container(
                            color: Colors.red,
                            child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.delete)),
                          ),
                          secondaryBackground: Container(
                            color: Colors.green,
                            child: const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.check)),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              _taskBloc.add(DeleteTask(state.task[index].id));
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              _taskBloc.add(UpdateTaskComplete(
                                  Status.done, state.task[index].id));
                            }
                          },
                          key: Key(state.task[index].id),
                          child: ListTaskWidget.navigate(
                              context, state.task[index]));
                    },
                    itemCount: state.task.length,
                  );
                }
                return const SizedBox.shrink();
              },
            );
          } else if (state is EmptyTaskState) {
            return const Center(
              child: Text("NO NEW TASK"),
            );
          } else if (state is LoadingTaskState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: TextButton(
                onPressed: () {
                  _taskBloc.add(GetAllTaskEvent());
                },
                child: const Text("RETRY"),
              ),
            );
          }
        },
      ),
    );
  }
}
