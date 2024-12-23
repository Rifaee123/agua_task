import 'package:agua_task/controller/task_controller.dart';
import 'package:agua_task/model/task_model.dart';
import 'package:agua_task/widgets/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 22, 58, 113),
      appBar: AppBar(
        title: Text('Task Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(
              "Hi, User",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "What tasks do you have today?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Search Bar

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search tasks',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(() {
                    List<Task> filteredTasks = taskController.tasks
                        .where((task) => task.title
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                    Map<String, List<Task>> groupedTasks = {};
                    for (var task
                        in filteredTasks.where((task) => !task.isCompleted)) {
                      if (!groupedTasks.containsKey(task.category)) {
                        groupedTasks[task.category] = [];
                      }
                      groupedTasks[task.category]!.add(task);
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: groupedTasks.keys.length,
                      itemBuilder: (context, categoryIndex) {
                        String category =
                            groupedTasks.keys.elementAt(categoryIndex);
                        List<Task> tasks = groupedTasks[category]!;

                        return ExpansionTile(
                          key: Key(category),
                          title: Text(category,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          children: tasks.map((task) {
                            return Dismissible(
                                key: Key(task.id),
                                background: Container(
                                  color: Colors.green,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Icon(Icons.check, color: Colors.white),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    taskController.markAsComplete(task.id);
                                  } else {
                                    taskController.deleteTask(task.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Task deleted'),
                                        action: SnackBarAction(
                                          label: 'UNDO',
                                          onPressed: () {
                                            taskController.tasks.add(task);
                                            taskController.tasksBox
                                                .put(task.id, task);
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: task.isCompleted
                                            ? Colors.green
                                            : Colors.orange,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          "${task.title}(${task.category})",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          task.description,
                                          style: const TextStyle(
                                              color: Colors.white70),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Icon(
                                          task.isCompleted
                                              ? Icons.check_circle
                                              : Icons.pending,
                                          color: Colors.white,
                                        ),
                                      )),
                                ));
                          }).toList(),
                        );
                      },
                    );
                  }),
                  Obx(() {
                    List<Task> completedTasks = taskController.tasks
                        .where((task) => task.isCompleted)
                        .toList();

                    if (completedTasks.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No completed tasks yet.',
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      );
                    }

                    return ExpansionTile(
                      key: Key("CompletedTasks"),
                      title: Text("Completed Tasks",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      children: completedTasks.map((task) {
                        return Dismissible(
                            key: Key(task.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              taskController.deleteTask(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Task deleted'),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      taskController.tasks.add(task);
                                      taskController.tasksBox
                                          .put(task.id, task);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: task.isCompleted
                                        ? Colors.green
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "${task.title}(${task.category})",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task.description,
                                      style: const TextStyle(
                                          color: Colors.white70),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Icon(
                                      task.isCompleted
                                          ? Icons.check_circle
                                          : Icons.pending,
                                      color: Colors.white,
                                    ),
                                  )),
                            ));
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Add Task Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Get.to(AddTaskScreen());
              },
              child: Text('Add Task'),
            ),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agua_task/controller/task_controller.dart';
// import 'package:agua_task/model/task_model.dart';
// import 'package:agua_task/widgets/add_task_screen.dart';

// class TaskListScreen extends StatefulWidget {
//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }

// class _TaskListScreenState extends State<TaskListScreen> {
//   final TaskController taskController = Get.put(TaskController());
//   final TextEditingController searchController = TextEditingController();
//   String searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 22, 58, 113),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Top App Bar with Icons
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.menu, color: Colors.white),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.notifications, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               // Greeting and Prompt
              // const Padding(
              //   padding: EdgeInsets.only(left: 15),
              //   child: Text(
              //     "Hi, User",
              //     style: TextStyle(color: Colors.white, fontSize: 16),
              //   ),
              // ),
              // const Padding(
              //   padding: EdgeInsets.only(left: 15),
              //   child: Text(
              //     "What tasks do you have today?",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 22,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
              // // Search Bar
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: Container(
              //     decoration: const BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.all(Radius.circular(15)),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 10),
              //       child: TextField(
              //         controller: searchController,
              //         onChanged: (query) {
              //           setState(() {
              //             searchQuery = query;
              //           });
              //         },
              //         decoration: const InputDecoration(
              //           labelText: 'Search tasks',
              //           border: InputBorder.none,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 15, top: 10),
//                 child: Text(
//                   "Your Tasks",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//               // Task List
//               Expanded(
//                 child: Obx(() {
//                   if (taskController.tasks.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'No tasks available.',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     );
//                   }

//                   List<Task> filteredTasks = taskController.tasks
//                       .where((task) => task.title
//                           .toLowerCase()
//                           .contains(searchQuery.toLowerCase()))
//                       .toList();

//                   return ListView.builder(
//                     itemCount: filteredTasks.length,
//                     itemBuilder: (context, index) {
//                       Task task = filteredTasks[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 15,
//                           vertical: 10,
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: task.isCompleted
//                                 ? Colors.green
//                                 : Colors.orange,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: ListTile(
//                             title: Text(
//                               task.title,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(
//                               task.description,
//                               style: const TextStyle(color: Colors.white70),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             trailing: Icon(
//                               task.isCompleted
//                                   ? Icons.check_circle
//                                   : Icons.pending,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }),
//               ),
//               // Add Task Button
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 235, 125, 35),
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   onPressed: () {
//                     Get.to(() => AddTaskScreen());
//                   },
//                   child: const Text(
//                     'Add Task',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

