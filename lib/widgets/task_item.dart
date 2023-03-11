import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    _localStorage = locator<LocalStorage>();

    super.initState();
  }

  Color mainColor = const Color.fromRGBO(30, 31, 40, 1);
  Color redThemeColor = const Color.fromRGBO(239, 54, 81, 1);

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: redThemeColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: redThemeColor.withOpacity(.6), blurRadius: 10),
        ],
      ),
      child: ListTile(
          leading: GestureDetector(
            onTap: () {
              widget.task.isCompleted = !widget.task.isCompleted;
              _localStorage.updateTask(task: widget.task);
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                color: mainColor,
                border: Border.all(color: redThemeColor, width: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check,
                color: widget.task.isCompleted ? redThemeColor : mainColor,
                size: 24,
              ),
            ),
          ),
          title: widget.task.isCompleted
              ? Text(
                  widget.task.name,
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey.shade800),
                )
              : TextField(
                  cursorColor: mainColor,
                  controller: _taskNameController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    widget.task.name = value;
                    _localStorage.updateTask(task: widget.task);
                  },
                  minLines: 1,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Yeni Görev',
                    hintStyle: TextStyle(color: mainColor),
                    border: InputBorder.none,
                  ),
                ),
          trailing: !widget.task.isCompleted
              ? Text(
                  DateFormat("hh:mm a").format(widget.task.createdAt),
                  style: TextStyle(
                      fontSize: 14,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                )
              : Text(
                  DateFormat("hh:mm a").format(widget.task.createdAt),
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey.shade800),
                )),
    );
  }
}
