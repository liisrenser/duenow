import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/todostorage.dart';
import '../../logic/todocontroller.dart';
import '../../models/todo.dart';
import '../widgets/todoitem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController _controller =
      TodoController(storage: TodoStorage());

  final TextEditingController _toDoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<ToDo> get todosList => _controller.todosList;

  void _handleToDoChange(ToDo todo) {
    setState(() {
      _controller.handleToDoChange(todo);
    });
    _controller.saveToDos();
  }

  void _deleteToDoItem(String id) {
    setState(() {
      _controller.deleteToDoItem(id);
    });
    _controller.saveToDos();
  }

  void _addToDoItem(String toDo) {
    if (toDo.trim().isEmpty) return;

    final selectedDueDate =
        _dateController.text.isEmpty ? null : _dateController.text;

    if (_controller.isDuplicateTask(toDo, selectedDueDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This task already exists for the selected date'),
        ),
      );
      return;
    }

    setState(() {
      _controller.addToDoItem(toDo, selectedDueDate);
    });

    _toDoController.clear();
    _dateController.clear();
    _controller.saveToDos();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _loadToDos() async {
    await _controller.loadToDos();
    setState(() {});
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
              color: const Color(0xFFFFE7BF),
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
                boxShadow: [
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
                  color: const Color(0xFFA10035),
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
                                  color: const Color(0xFFA10035),
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
