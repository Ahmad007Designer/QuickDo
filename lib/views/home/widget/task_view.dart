import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/home/components/rep_text_field.dart';
import 'package:todo_app/views/home/widget/tasl_view_app_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    required this.task,
  });

  final TextEditingController taskControllerForTitle;
  final TextEditingController taskControllerForSubtitle;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late TextEditingController taskControllerForTitle;
  late TextEditingController taskControllerForSubtitle;

  String title = '';
  String subTitle = '';

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    taskControllerForTitle = widget.taskControllerForTitle;
    taskControllerForSubtitle = widget.taskControllerForSubtitle;

    if (widget.task != null) {
      taskControllerForTitle.text = widget.task!.title;
      taskControllerForSubtitle.text = widget.task!.subtitle;
      selectedDate = widget.task!.createdAtDate;
      selectedTime = TimeOfDay.fromDateTime(widget.task!.createdAtTime);
    }
  }

  ///If Task is Already exists
  bool isTaskAlreadyExistBool() {
    if (widget.taskControllerForTitle.text.isEmpty ||
        widget.taskControllerForSubtitle.text.isEmpty) {
      return true;
    } else {
      return false;
    }
    // return widget.task != null;
  }

  /// Main function for creating or updating a task.
  /// If the user tries to update a task but leaves fields empty, a warning is shown.

  void isTaskAlreadyExistUpdateTask() {
    String title = taskControllerForTitle.text.trim();
    String subtitle = taskControllerForSubtitle.text.trim();

    if (title.isEmpty || subtitle.isEmpty) {
      emptyFieldsWarning(context);
      return;
    }

    // ✅ If editing an existing task
    if (widget.task != null) {
      try {
        widget.task!.title = title;
        widget.task!.subtitle = subtitle;
        widget.task!.createdAtDate = selectedDate;
        widget.task!.createdAtTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        widget.task!.save(); // ✅ Directly save Hive object

        BaseWidget.of(context).dataStore.refreshTasks();
        Navigator.of(context).pop();
      } catch (error) {
        // Handle errors
      }
    } else {
      // ✅ Creating a new task
      var task = Task.create(
        title: title,
        createdAtTime: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        ),
        createdAtDate: selectedDate,
        subtitle: subtitle,
      );

      BaseWidget.of(context).dataStore.addTask(task: task);
      BaseWidget.of(context).dataStore.refreshTasks();
      Navigator.of(context).pop();
    }
  }

  void deleteTask() {
    if (widget.task != null) {
      widget.task!.delete();
      Navigator.of(context).pop();
    }
  }

  ///pcicker Time
  void _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  ///date picker
  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: TaskViewAppBar(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopSideTexts(context, textTheme),
                      SizedBox(height: 20),
                      _buildMainTaskActivity(textTheme, context),
                      SizedBox(height: 30),
                      _buildBottomSideButtons(), // No Spacer used
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopSideTexts(BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                isTaskAlreadyExistBool()
                    ? MyString.addNewTask
                    : MyString.updateCurrentTask,
            style: textTheme.displayLarge,
            children: [
              TextSpan(
                text: MyString.taskStrnig,
                style: textTheme.displayLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainTaskActivity(TextTheme textTheme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            MyString.titleOfTitleTextField,
            style: textTheme.headlineMedium,
          ),
        ),
        SizedBox(height: 20),

        /// Task Title
        RepTextField(
          controller: widget.taskControllerForTitle,
          onChanged: (inputTitle) => title = inputTitle,
          onFieldSubmitted: (inputTitle) => title = inputTitle,
        ),
        SizedBox(height: 20),

        /// Description
        RepTextField(
          controller: widget.taskControllerForSubtitle,
          isForDescription: true,
          onChanged: (inputSubTitle) => subTitle = inputSubTitle,
          onFieldSubmitted: (inputSubTitle) => subTitle = inputSubTitle,
        ),
        SizedBox(height: 20),

        /// Time Section
        GestureDetector(
          onTap: () => _pickTime(context),
          child: Container(
            width: double.infinity,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(MyString.timeString, style: textTheme.headlineSmall),
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100,
                  ),
                  child: Center(
                    child: Text(
                      selectedTime.format(context),
                      style: textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),

        /// Date Section
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            width: double.infinity,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Select Date", style: textTheme.headlineSmall),
                Container(
                  width: 150,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100,
                  ),
                  child: Center(
                    child: Text(
                      DateFormat("EEE, dd MMM, yyyy").format(selectedDate),
                      style: textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment:
            isTaskAlreadyExistBool()
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
        children: [
          if (!isTaskAlreadyExistBool())
            /// Delete Task Button
            MaterialButton(
              onPressed: deleteTask,
              minWidth: 150,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              height: 55,
              child: Row(
                children: [
                  Icon(Icons.close, color: AppColors.primaryColor),
                  SizedBox(width: 5),
                  Text(
                    MyString.deleteTask,
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),

          /// Add/Update Task Button
          MaterialButton(
            onPressed: isTaskAlreadyExistUpdateTask,
            minWidth: 150,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 55,
            child: Row(
              children: [
                Icon(
                  isTaskAlreadyExistBool() ? Icons.add : Icons.update,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text(
                  isTaskAlreadyExistBool()
                      ? MyString.addNewTask
                      : MyString.updateCurrentTask,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
