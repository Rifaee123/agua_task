// TaskController.dart
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:agua_task/model/task_model.dart';

class TaskController extends GetxController {
  final tasksBox = Hive.box<Task>('tasks');
  RxList<Task> tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.addAll(tasksBox.values);
  }

  void addTask(Task task) {
    tasksBox.put(task.id, task);
    tasks.add(task);
  }

  void deleteTask(String taskId) {
    tasksBox.delete(taskId);
    tasks.removeWhere((task) => task.id == taskId);
  }

  void markAsComplete(String taskId) {
    Task task = tasks.firstWhere((task) => task.id == taskId);
    task.isCompleted = true;
    tasksBox.put(task.id, task);

    tasks.removeWhere((task) => task.id == taskId);
    tasks.add(task);
  }
}
