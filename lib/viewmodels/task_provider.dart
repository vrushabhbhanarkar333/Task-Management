import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/models/task_model.dart';
import 'package:task_management_app/services/database_services.dart';

final taskViewModelProvider =
    StateNotifierProvider<TaskViewModel, List<Task>>((ref) {
  return TaskViewModel();
});

class TaskViewModel extends StateNotifier<List<Task>> {
  TaskViewModel() : super([]);

  Future<void> loadTasks() async {
    final tasks = await TaskDatabase.instance.getAllTasks();
    state = tasks;
  }

  Future<void> addTask(Task task) async {
    await TaskDatabase.instance.insertTask(task);
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await TaskDatabase.instance.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.instance.deleteTask(id);
    loadTasks();
  }
}
