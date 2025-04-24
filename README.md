# To-Do List App (iOS)

A simple iOS to-do list app built with SwiftUI. Users can create, edit, and manage tasks with tags, reminders, and filtering features.

## Features

- Add and delete tasks
- Set optional reminders for tasks
- Assign custom tags to tasks
- Filter tasks by tag
- Search tasks by title
- Create and manage tags separately
- Simple and clean SwiftUI interface

## Requirements

- iOS 15.0+
- Xcode 13+
- Swift 5.5+

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ToDoList.git
   ```
2. Open the `.xcodeproj` file in Xcode.
3. Run the project on a simulator or physical device.

## Folder Structure

- `ContentView.swift`: Main UI with search, tags, and task list
- `TaskManager.swift`: ObservableObject managing tasks and tags
- `TaskRow.swift`: Reusable row view for displaying each task
- `NewTaskView.swift`: View for adding new tasks

## License

This project is licensed under the MIT License.
