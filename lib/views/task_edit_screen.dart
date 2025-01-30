import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/models/task_model.dart';
import 'package:task_management_app/viewmodels/task_provider.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final Task task;
  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateTask() {
    final updatedTask = widget.task.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
    );

    ref.read(taskViewModelProvider.notifier).updateTask(updatedTask);
    Navigator.pop(context); // Close the screen after updating
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Edit',
          style: TextStyle(
              fontSize: screenWidth > 600 ? 26 : 22,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: isTablet ? 50 : 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Task",
              style: TextStyle(
                fontSize: isTablet ? 26 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: isTablet ? 22 : 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: isTablet ? 22 : 16),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _updateTask,
                icon: Icon(Icons.save),
                label: Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 20 : 14, horizontal: 30),
                  textStyle: TextStyle(fontSize: isTablet ? 22 : 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
