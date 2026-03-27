import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:duenow/widgets/todoitem.dart';
import 'package:duenow/model/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final todosList = ToDo.todoList();
  final _toDoController = TextEditingController();

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo) {
    if (toDo.trim().isEmpty) return;

    setState(() {
      todosList.add(
        ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDo,
        ),
      );
    });
    _toDoController.clear();
  }

  @override
  void dispose() {
    _toDoController.dispose();
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
          backgroundColor: const Color(0xFFFFC4C4),
          title: Text(
            'DueNow',
            style: GoogleFonts.merriweather(
              fontSize: 30,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE7BF),
              ),
              child: Text(
                'All TODOs',
                style: GoogleFonts.merriweather(
                  fontSize: 25,
                  color: Colors.black,
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
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC4C4),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _toDoController,
                          decoration: const InputDecoration(
                            hintText: 'Add a new todo item',
                            border: InputBorder.none,
                          ),
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
                            color: Colors.grey,
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