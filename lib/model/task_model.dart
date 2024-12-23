import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category;

  @HiveField(4)
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
  }) : id = Uuid().v4(); 
}
