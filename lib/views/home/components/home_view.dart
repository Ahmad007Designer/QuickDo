import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/home/components/fab.dart';
import 'package:todo_app/views/home/components/home_app_bar.dart';
import 'package:todo_app/views/home/components/slider_drawer.dart';
import 'package:todo_app/views/home/components/task_widget.dart';
import 'package:animate_do/animate_do.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  ///Length of Indicator
  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  /// Count the Done Task
  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
      builder: (ctx, box, child) {
        ///Sort the list according to date
        var tasks = box.values.toList();
        tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: const Fab(),
          body: Stack(
            children: [
              SliderDrawer(
                key: drawerKey,
                appBar: const SizedBox.shrink(), // Removed default AppBar
                isDraggable: false,
                animationDuration: Duration(milliseconds: 500).inMilliseconds,
                slider: CustomDrawer(),
                child: _buildHomeBody(textTheme, base, tasks),
              ),
              Positioned(
                top: 30,
                left: 0,
                right: 0,
                child: HomeAppBar(drawerKey: drawerKey),
              ),
            ],
          ),
        );
      },
    );
  }

  ///Home Body
  Widget _buildHomeBody(
    TextTheme textTheme,
    BaseWidget base,
    List<Task> tasks,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 80),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MyString.mainTitle, style: textTheme.displayLarge),
                    const SizedBox(height: 3),
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length} task",
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(thickness: 2, indent: 100),
            Expanded(
              child:
                  tasks.isNotEmpty
                      ///Task list is not empty
                      ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          ///Get Single TAsk for Showing in Lisst
                          var task = tasks[index];
                          return Dismissible(
                            // key: Key(tasks[index].toString()),
                            direction: DismissDirection.horizontal,

                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              color: Colors.red.shade100,
                              child: const Row(
                                children: [
                                  Icon(Icons.delete_outline, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    "Task Removed",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                              base.dataStore.dalateTask(task: task);
                            },
                            key: Key(task.id),
                            child: TaskWidget(task: task),
                          );
                        },
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeIn(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Lottie.asset(lottieURL, animate: true),
                            ),
                          ),
                          FadeInUp(from: 30, child: Text(MyString.doneAllTask)),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
