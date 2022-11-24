import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application_using_bloc/user_interface_layer/TaskHomePage/bloc/task_bloc.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  const CreateTaskBottomSheet({Key? key}) : super(key: key);

  static showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return CreateTaskBottomSheet();
        });
  }

  @override
  State<CreateTaskBottomSheet> createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final validCharacters = RegExp(r'^[a-zA-Z0-9_ ]+$');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(context).padding.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Title Required";
                    } else if (!validCharacters.hasMatch(val)) {
                      return "Invalid input";
                    }
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(15)],
                  decoration: const InputDecoration(
                    labelText: "Title *",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descController,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  decoration: const InputDecoration(
                    labelText: "Description",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    Duration? time;
                    await showDurationPicker(
                            context: context,
                            initialTime: const Duration(minutes: 1),
                            baseUnit: BaseUnit.minute)
                        .then((value) {
                      setState(() {
                        time = value;
                      });
                    });

                    timeController.text = time?.inMinutes.toString() ?? "";
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: timeController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Duration Required";
                        } else if (int.parse(val) > 10) {
                          return "Invalid input";
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: "Duration", hintText: "Select Duration"),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        context.read<TaskBloc>().add(CreateTaskEvent(
                            title: titleController.text,
                            desc: descController.text,
                            duration: Duration(
                                minutes: int.parse(timeController.text))));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Create Task"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
