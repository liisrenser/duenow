import '../data/todostorage.dart';
import '../models/todo.dart';

class TodoController {
  final List<ToDo> todosList = ToDo.todoList();
  final TodoStorage storage;

  TodoController({required this.storage});

  void handleToDoChange(ToDo todo) {
    todo.isDone = !todo.isDone;
    sortToDos();
  }

  void deleteToDoItem(String id) {
    todosList.removeWhere((item) => item.id == id);
  }

  bool isDuplicateTask(String toDo, String? dueDate) {
    return todosList.any(
      (item) =>
          item.todoText!.trim().toLowerCase() == toDo.trim().toLowerCase() &&
          item.dueDate == dueDate,
    );
  }

  void addToDoItem(String toDo, String? dueDate) {
    if (toDo.trim().isEmpty) return;

    todosList.add(
      ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
        dueDate: dueDate,
      ),
    );

    sortToDos();
  }

  void sortToDos() {
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

  Future<void> saveToDos() async {
    await storage.saveToDos(todosList);
  }

  Future<void> loadToDos() async {
    final loadedToDos = await storage.loadToDos();

    if (loadedToDos.isNotEmpty) {
      todosList.clear();
      todosList.addAll(loadedToDos);
    }

    sortToDos();
  }
}
