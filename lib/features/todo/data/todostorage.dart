import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoStorage {
  static const String storageKey = 'todos';

  Future<void> saveToDos(List<ToDo> todosList) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> todoJsonList =
        todosList.map((todo) => jsonEncode(todo.toJson())).toList();

    await prefs.setStringList(storageKey, todoJsonList);
  }

  Future<List<ToDo>> loadToDos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? todoJsonList = prefs.getStringList(storageKey);

    if (todoJsonList != null && todoJsonList.isNotEmpty) {
      return todoJsonList
          .map((item) => ToDo.fromJson(jsonDecode(item)))
          .toList();
    }

    return [];
  }
}
