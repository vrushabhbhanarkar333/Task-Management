import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/viewmodels/task_provider.dart';
import 'package:task_management_app/views/task_edit_screen.dart';
import 'add_task_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(taskViewModelProvider.notifier).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskViewModelProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: TextStyle(
              fontSize: screenWidth > 600 ? 26 : 22,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: tasks.isEmpty
          ? _buildEmptyState(screenWidth)
          : Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 10),
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _buildTaskCard(task);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _buildTaskCard(task) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: task.isCompleted ? Colors.green : Colors.grey,
          child: Icon(Icons.task_alt, color: Colors.white),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          task.description,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              shape: CircleBorder(),
              activeColor: Colors.deepPurple,
              value: task.isCompleted,
              onChanged: (value) {
                ref
                    .read(taskViewModelProvider.notifier)
                    .updateTask(task.copyWith(isCompleted: value));
              },
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                _confirmDelete(context, task.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(taskViewModelProvider.notifier)
                  .deleteTask(taskId as int);
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double screenWidth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task,
              size: screenWidth > 600 ? 100 : 80, color: Colors.deepPurple),
          SizedBox(height: 10),
          Text(
            'No tasks yet!',
            style: TextStyle(
                fontSize: screenWidth > 600 ? 24 : 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'Tap the + button to add a new task.',
            style: TextStyle(
                fontSize: screenWidth > 600 ? 18 : 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
