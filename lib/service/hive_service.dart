import 'package:agua_task/model/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';




class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>('tasks');
  }

  static Box<Task> getTaskBox() => Hive.box<Task>('tasks');
}

