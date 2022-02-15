import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/utils.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TodoApp()
    );
  }
}



class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<Todo> _todos = <Todo>[];
  final GlobalKey<_TodoAppState> _key = GlobalKey<_TodoAppState>();

  Future _openCreateTodoDialogPopup() {
    final textController = TextEditingController();
    DateTime? deadline;

    return showAnimatedDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a new Todo"),
        content: Stack(
          children: <Widget>[
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: "Enter todo..",
              ),
              maxLength: 100,
              minLines: 1,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Create Todo"),
            onPressed: () => {
              setState(() => {
                if (deadline == null)
                  _todos.add(Todo(textController.text, false))
                else
                  _todos.add(Todo(textController.text, false, deadline))
              }),

              // close the popup
              Navigator.of(context).pop()
            }
          ),
          TextButton(
            child: const Text("Set deadline"),
            onPressed: () => {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime(DateTime.now().year, DateTime.december), // deadlines for todos can't be more than a year
                onConfirm: (date) => deadline = date,
              )
            },
          )
        ],
      ),
      duration: const Duration(milliseconds: 380),
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
    );

    // return showAnimatedDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Text("Create a new todo"),
    //       content: Form(
    //         child: Stack(
    //           children: <Widget>[
    //             TextFormField(
    //               controller: textController,
    //               autofocus: true,
    //               decoration: const InputDecoration(
    //                 hintText: "Enter todo.."
    //               ),
    //               validator: (value) {
    //                 if (value == null || value.isEmpty) {
    //                   return 'Please enter some text';
    //                 }
    //                 return null;
    //               },
    //             )
    //           ],
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           child: const Text("Create Todo"),
    //           onPressed: () => {
    //             if (_key.currentState?.validate()) {
    //               setState(() => {
    //                 if (deadline == null)
    //                   _todos.add(Todo(textController.text, false))
    //                 else
    //                   _todos.add(Todo(textController.text, false, deadline))
    //               })
    //             }
    //           },
    //         ),
    //       ],
    //     )
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Todo"),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          if (_todos.isNotEmpty) {
            if (_todos[index].completed == false) {
              return ListTile(
                title: Text(_todos[index].todo),
                trailing: Checkbox(
                  value: _todos[index].completed,
                  onChanged: (bool? value) {
                    setState(() => {
                      //_todos[index].completed = value!
                      _todos.removeAt(index)
                    });
                  },
                ),
                subtitle: Text(_todos[index].deadline == null ?
                    "no due date."
                    : "due by ${DateUtilities.format(_todos[index].deadline!)}"),
              );
            } else {
              return const Center(
                child: Text("hello"),
              );
            }
          } else {
            return const Center(
              child: Text("no todos"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {
          _openCreateTodoDialogPopup()
        }
      ),
    );
  }
}


