import 'package:agua_task/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProgressIndicatorWidget extends StatelessWidget {
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int totalTasks = taskController.tasks.length;
      int completedTasks = taskController.tasks.where((task) => task.isCompleted).length;
      double progress = totalTasks == 0 ? 0 : completedTasks / totalTasks;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Completed: ${(progress * 100).toStringAsFixed(1)}%'),
            SizedBox(height: 10),
            LinearProgressIndicator(value: progress),
          ],
        ),
      );
    });
  }
}
