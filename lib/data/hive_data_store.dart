import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

///
import '../models/task.dart';

class HiveDataStore {
  static const boxName = "tasksBox";
  final Box<Task> box = Hive.box<Task>(boxName);

  ///All CRUD operation for hive DB

  /// Add new Task
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  /// Show task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  /// Update task
  Future<void> updateTask({required Task task}) async {
    await box.put(task.id, task);
  }

  /// Remove task by ID
  Future<void> removeTaskById({required String id}) async {
    await box.delete(id);
  }

  /// Delete task
  Future<void> dalateTask({required Task task}) async {
    await task.delete();
  }

  /// Refresh task list by triggering a UI update
  void refreshTasks() {
    /// This will trigger updates in the UI when the Hive box changes
    box.listenable().addListener(() {
      debugPrint("Task data has changed, refreshing UI...");
    });
  }

  ///Listen to Box Changes
  ///using this method we will listes to box changes and updated the UI accordingly
  ValueListenable<Box<Task>> listenToTask() {
    return box.listenable();
  }
}
