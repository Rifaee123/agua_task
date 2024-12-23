import 'package:agua_task/controller/task_controller.dart';
import 'package:agua_task/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final int index;
  final TaskController taskController;

  TaskTile({
    required this.task,
    required this.index,
    required this.taskController,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(task.title),
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => taskController.markAsComplete(index.toString()),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Complete',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              taskController.deleteTask(index.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task deleted'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      taskController.tasks.insert(index, task);
                      taskController.tasksBox.putAt(index, task);
                    },
                  ),
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description, overflow: TextOverflow.ellipsis),
        trailing: task.isCompleted
            ? Icon(Icons.check, color: Colors.green)
            : Text('Pending', style: TextStyle(color: Colors.orange)),
      ),
    );
  }
}
