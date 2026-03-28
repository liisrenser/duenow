# DueNow

A simple and clean Flutter todo application that allows users to create, manage, and track tasks with optional due dates.

The app focuses on clean architecture, local persistence, and clear separation of concerns while maintaining a simple and user-friendly interface.


## Why I built this

I chose to build a todo list application with automatic priority sorting because it solves a real problem I experience daily.

Often, I write down tasks but still have to manually decide what to do first. I wanted an app where I can simply enter tasks, assign due dates, and let the app automatically suggest the correct order based on urgency.

This project reflects that idea: reducing decision fatigue by letting the system organize tasks for you.


## Features

- Add todo items
- Optional due dates for tasks
- Visual urgency indicators:
  - Red for tasks due soon
  - Yellow for upcoming tasks
- Automatic sorting:
  - incomplete tasks first
  - tasks sorted by nearest due date
- Mark tasks as completed
- Delete tasks
- Local persistence using SharedPreferences
- Duplicate task validation


## Project Structure

The project follows a feature-based architecture:
```bash
lib/
├── app/
├── features/
│ └── todo/
│ ├── data/ # Local storage (SharedPreferences)
│ ├── logic/ # Business logic (controller)
│ ├── models/ # Data models
│ └── presentation/ # UI (screens & widgets)
```

### Layers

- **Presentation** → UI and user interaction  
- **Logic** → business rules (add, delete, sort, validate)  
- **Data** → persistence and storage  
- **Models** → data structure  


##  Data Flow

1. User interacts with the UI (`HomeScreen`)
2. UI calls methods in `TodoController`
3. `TodoController`:
   - updates the in-memory todo list
   - applies sorting and validation
4. After each change:
   - data is passed to `TodoStorage`
5. `TodoStorage`:
   - converts todos to JSON
   - saves them using SharedPreferences
6. On app startup:
   - data is loaded from storage
   - converted back into objects
   - sorted and displayed


## Getting Started

### Requirements

- Flutter SDK installed
- Android Studio / VS Code
- Emulator or physical device

### Installation

Clone the repository:

```bash
git clone https://github.com/your-username/duenow.git
```
Navigate to the project folder:
```bash
cd duenow
```
Install dependencies:
```bash
flutter pub get
```
Run the app:
```bash
flutter run
```
## How to Use

- Enter a task in the input field  
- (Optional) Select a due date using the calendar icon  
- Press '+' to add the task  
- Tap a task to mark it as completed  
- Press delete icon to delete a task  

## Learning & Resources

This was my first time working with Flutter.  
To learn and complete this project, I used the following resources:

- Flutter official documentation  
- YouTube tutorials  : https://www.youtube.com/watch?v=1xipg02Wu8s&list=PLKijLlRJO9vROKcVCZY9JFKg0H5cql2MX, https://www.youtube.com/watch?v=K4P5DZ9TRns&list=PLKijLlRJO9vROKcVCZY9JFKg0H5cql2MX&index=2, https://www.youtube.com/watch?v=UrZL8-DrtHM&list=PLKijLlRJO9vROKcVCZY9JFKg0H5cql2MX&index=3
- Online articles and guides  : https://medium.com/@bmselvam001/%EF%B8%8F-local-storage-in-flutter-full-guide-5b53665bb737, https://softradixtechnology.hashnode.dev/step-by-step-guide-to-flutter-folder-structure-for-better-organization, https://pub.dev/packages/shared_preferences, 





