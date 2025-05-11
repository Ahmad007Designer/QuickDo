import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/constants.dart';

class HomeAppBar extends StatefulWidget {
  final GlobalKey<SliderDrawerState> drawerKey;

  const HomeAppBar({super.key, required this.drawerKey});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void onDrawerToggle() {
    if (widget.drawerKey.currentState != null) {
      setState(() {
        isDrawerOpen = !isDrawerOpen;
        if (isDrawerOpen) {
          animationController.forward();
          widget.drawerKey.currentState!.openSlider();
        } else {
          animationController.reverse();
          widget.drawerKey.currentState!.closeSlider();
        }
      });
    }
  }

  // void emptyWarning(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Warning"),
  //         content: const Text("Are you sure you want to empty the trash?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Add your logic for emptying the trash here
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text("Empty"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return Container(
      height: 70,
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onDrawerToggle,
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: animationController,
              size: 32,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              // Trash icon action
              base.isEmpty ? warningNoTask(context) : deleteAllTask(context);
            },
            icon: const Icon(
              CupertinoIcons.trash,
              size: 28,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
