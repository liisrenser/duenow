import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:duenow/widgets/todoitem.dart';
import 'package:duenow/model/todo.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final todosList = ToDo.todoList();
  final _toDoController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  static const String _storageKey = 'todos';

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      _sortToDos();
    });
    _saveToDos();
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
    _saveToDos();
  }

  void _addToDoItem(String toDo) {
    if (toDo.trim().isEmpty) return;

    final selectedDueDate =
      _dateController.text.isEmpty ? null : _dateController.text;

    if (_isDuplicateTask(toDo, selectedDueDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This task already exists for the selected date'),
        ),
      );
      return;
    }

    setState(() {
      todosList.add(
        ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDo,
          dueDate: _dateController.text.isEmpty ? null : _dateController.text,
        ),
      );
      _sortToDos();
    });
    _toDoController.clear();
    _dateController.clear();
    _saveToDos();
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026),
      lastDate: DateTime(2100)
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  void _sortToDos() {
    todosList.sort((a, b) {
      if (a.isDone != b.isDone) {
      return a.isDone ? 1 : -1;
    }
    if (a.dueDate == null && b.dueDate == null) return 0;
    if (a.dueDate == null) return 1;
    if (b.dueDate == null) return -1;

    final dateA = DateTime.parse(a.dueDate!);
    final dateB = DateTime.parse(b.dueDate!);

    return dateA.compareTo(dateB);
    });
  }

  bool _isDuplicateTask(String toDo, String? dueDate) {
  return todosList.any(
    (item) =>
        item.todoText!.trim().toLowerCase() == toDo.trim().toLowerCase() &&
        item.dueDate == dueDate,
  );
  }

  Future<void> _saveToDos() async {
  final prefs = SharedPreferencesAsync();
  final List<String> todoJsonList =
      todosList.map((todo) => jsonEncode(todo.toJson())).toList();

  await prefs.setStringList(_storageKey, todoJsonList);
  }

  Future<void> _loadToDos() async {
    final prefs = SharedPreferencesAsync();
    final List<String>? todoJsonList = await prefs.getStringList(_storageKey);

    if (todoJsonList != null && todoJsonList.isNotEmpty) {
      setState(() {
        todosList.clear();
        todosList.addAll(
          todoJsonList.map((item) => ToDo.fromJson(jsonDecode(item))).toList(),
        );
        _sortToDos();
      });
      } else {
      setState(() {
        _sortToDos();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToDos();
  }

  @override
  void dispose() {
    _toDoController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        overscroll: false,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFFF869E),
          title: Text(
            'DueNow',
            style: GoogleFonts.merriweather(
              fontSize: 30,
              color: Color(0xFFFFE7BF)
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFFC4C4),
                boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFFF869E),
                              blurRadius: 5,
                              spreadRadius: 0,
                            ),
                          ],
              ),
              child: Text(
                'All TODOs',
                textAlign: TextAlign.center,
                style: GoogleFonts.merriweather(
                  fontSize: 25,
                  color: Color(0xFFA10035),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    for (ToDo todo in todosList)
                      ToDoItem(
                        todo: todo,
                        onToDoChanged: _handleToDoChange,
                        onDeleteItem: _deleteToDoItem,
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC4C4),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFFF869E),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _toDoController,
                                    decoration: const InputDecoration(
                                      hintText: 'Add a new todo item',
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  color: Color(0xFFA10035),
                                  onPressed: () {
                                    _selectDate();
                                  },
                                ),
                              ],
                            ),
                            if (_dateController.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Due: ${_dateController.text}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC4C4),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFFF869E),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          _addToDoItem(_toDoController.text);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xFFA10035),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}