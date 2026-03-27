class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo ({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Morning Exercise', isDone: true),
      ToDo(id: '02', todoText: 'Buy Groceries', isDone: true),
      ToDo(id: '03', todoText: 'Check Emails'),
      ToDo(id: '04', todoText: 'Team Meeting'),
      ToDo(id: '05', todoText: 'Work on mobile apps for 2 hour'),
      ToDo(id: '06', todoText: 'Dinner with Jenny'),
      ToDo(id: '07', todoText: 'Morning Exercise', isDone: true),
      ToDo(id: '08', todoText: 'Buy Groceries', isDone: true),
      ToDo(id: '09', todoText: 'Check Emails'),
      ToDo(id: '10', todoText: 'Team Meeting'),
      ToDo(id: '11', todoText: 'Work on mobile apps for 2 hour'),
      ToDo(id: '12', todoText: 'Dinner with Jenny'),
    ];
  }
}