class ToDo {
  String? id;
  String? todoText;
  String? dueDate;
  bool isDone;

  ToDo ({
    required this.id,
    required this.todoText,
    this.dueDate,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Morning Exercise', dueDate: '2026-03-30', isDone: true),
      ToDo(id: '02', todoText: 'Buy Groceries', dueDate: '2026-04-01', isDone: true),
      ToDo(id: '03', todoText: 'Check Emails'),
      ToDo(id: '04', todoText: 'Team Meeting'),
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todoText': todoText,
      'dueDate': dueDate,
      'isDone': isDone,
    };
  }

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      todoText: json['todoText'],
      dueDate: json['dueDate'],
      isDone: json['isDone'] ?? false,
    );
  }
}