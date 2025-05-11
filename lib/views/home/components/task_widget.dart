import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/views/home/widget/task_view.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key, required this.task});

  final Task task;

  @override
  TaskWidgetState createState() => TaskWidgetState();
}

class TaskWidgetState extends State<TaskWidget> {
  TextEditingController taskControllerForTitle = TextEditingController();
  TextEditingController taskControllerForSubtitle = TextEditingController();

  @override
  void initState() {
    taskControllerForTitle.text = widget.task.title;
    taskControllerForSubtitle.text = widget.task.subtitle;
    super.initState();
  }

  @override
  void dispose() {
    taskControllerForTitle.dispose();
    taskControllerForSubtitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder:
                (ctx) => TaskView(
                  taskControllerForTitle: taskControllerForTitle,
                  taskControllerForSubtitle: taskControllerForSubtitle,
                  task: widget.task,
                ),
          ),
        );
      },

      ///Main Card
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              widget.task.isCompleted
                  ? AppColors.primaryColor.withAlpha(77)
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),

        child: ListTile(
          /// check icon
          leading: GestureDetector(
            onTap: () {
              widget.task.isCompleted = !widget.task.isCompleted;
              widget.task.save();
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    widget.task.isCompleted
                        ? AppColors.primaryColor
                        : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.8),
              ),
              child: Icon(Icons.check, size: 16, color: Colors.white),
            ),
          ),

          ///Title of Task
          title: Padding(
            padding: EdgeInsets.only(bottom: 5, top: 3),
            child: Text(
              taskControllerForTitle.text,
              style: TextStyle(
                fontSize: 16,
                color:
                    widget.task.isCompleted
                        ? AppColors.primaryColor
                        : Colors.black,
                fontWeight: FontWeight.w800,
                decoration:
                    widget.task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),

          ///Subtitle of Task
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                taskControllerForSubtitle.text,
                style: TextStyle(
                  color:
                      widget.task.isCompleted
                          ? AppColors.primaryColor
                          : Colors.black,
                  fontSize: 16,
                  decoration:
                      widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                ),
              ),

              ///date select
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(widget.task.createdAtTime),
                        style: TextStyle(
                          color:
                              widget.task.isCompleted
                                  ? Colors.white
                                  : Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMEd().format(widget.task.createdAtDate),
                        style: TextStyle(
                          color:
                              widget.task.isCompleted
                                  ? Colors.white
                                  : Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
