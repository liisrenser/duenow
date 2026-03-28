import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final ValueChanged<ToDo> onToDoChanged;
  final ValueChanged<String> onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onDeleteItem,
    required this.onToDoChanged,
  }) : super(key: key);

  Color? _getDueDateColor(String? dueDate) {
    if (dueDate == null || dueDate.isEmpty) return null;

    final due = DateTime.parse(dueDate);
    final now = DateTime.now();

    final difference = due.difference(now).inDays;

    if (difference <= 2) {
      return const Color.fromARGB(255, 249, 36, 20);
    } else if (difference <= 6) {
      return const Color.fromARGB(255, 255, 232, 27);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              todo.isDone
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: const Color(0xFFA10035),
            ),
            const SizedBox(width: 6),
            if (_getDueDateColor(todo.dueDate) != null)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _getDueDateColor(todo.dueDate),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        title: Text(
          todo.todoText!,
          style: GoogleFonts.merriweather(
            fontSize: 16,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: todo.dueDate != null && todo.dueDate!.isNotEmpty
            ? Text(
                'Due: ${todo.dueDate}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              )
            : null,
        trailing: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: const Color(0xFFA10035),
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.delete),
            onPressed: () {
              onDeleteItem(todo.id!);
            },
          ),
        ),
      ),
    );
  }
}
