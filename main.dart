import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Map<String, dynamic>> _todos = [
    {'title': 'Do exercise', 'time': '800 am', 'done': false},
    {'title': 'Buy vegetables', 'time': '800 am', 'done': false},
    {'title': 'Make veg salad', 'time': '1000 am', 'done': false},
    {'title': 'Go to shopping', 'time': '600 pm', 'done': false},
  ];

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  void _addTodo() async {
    final newTask = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time (e.g., 800 am)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_taskController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'title': _taskController.text,
                  'time': _timeController.text,
                  'done': false
                });
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );

    if (newTask != null) {
      setState(() {
        _todos.add(newTask);
        _taskController.clear();
        _timeController.clear();
      });
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) => ListTile(
          leading: Checkbox(
            value: _todos[index]['done'],
            onChanged: (value) => setState(() => _todos[index]['done'] = value),
          ),
          title: Text(
            _todos[index]['title'],
            style: TextStyle(
              decoration:
                  _todos[index]['done'] ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(_todos[index]['time']),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTodo(index),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: Icon(Icons.add),
        tooltip: 'Add New Task',
      ),
    );
  }
}
