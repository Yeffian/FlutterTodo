import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _lightMode = false;
  ThemeData? _theme = null;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  void _setDarkMode(bool darkOrLight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', darkOrLight ? 'dark' : 'light');

    setState(() => {
      _lightMode = darkOrLight
    });
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() => {
       _lightMode = prefs.getString('theme') == 'dark' ? false : true
    });
  }

  void _useTheme() async {
    setState(() => {
      _theme = _lightMode ? ThemeData.light() : ThemeData.dark()
    });
  }

  @override
  void initState() {
    _loadTheme();
    _useTheme();
    super.initState();
  }

  Future _openCreateTodoDialogPopup() {
    final textController = TextEditingController();
    DateTime? deadline;

    return showAnimatedDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Create a todo"
                ),
                SafeArea(
                  child: TextFormField(
                    autofocus: true,
                    controller: textController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cannot create empty todo";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Enter todo.."
                    ),
                  ),
                )
              ],
            ),
          ),
            actions: <Widget>[
              TextButton(
                child: const Text("Create Todo"),
                onPressed: () => {
                  if (_key.currentState!.validate()) {
                    setState(() => {
                      if (deadline == null)
                        _todos.add(Todo(textController.text, false))
                      else
                        _todos.add(Todo(textController.text, false, deadline))
                    }),

                    Navigator.of(context).pop(),
                  },
                },
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Todo',
        debugShowCheckedModeBanner: false,
        theme: _theme,
        home: Scaffold(
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
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text(
                          "Dark Mode"
                        ),
                        Switch(
                          value: _lightMode,
                          onChanged: (value) => {
                            _setDarkMode(value),
                            _useTheme(),
                          },
                        )
                      ],
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}


