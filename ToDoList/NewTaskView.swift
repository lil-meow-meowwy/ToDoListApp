//
//  NewTaskView.swift
//  ToDoList
//
//  Created by Kristina Yaroshenko on 24.04.2025.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var manager: TaskManager
    
    @State private var title = ""
    @State private var selectedTag = "General"
    @State private var reminder = false
    @State private var reminderDate = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Title")) {
                    TextField("Enter task", text: $title)
                }

                Section(header: Text("Tag")) {
                    Picker("Tag", selection: $selectedTag) {
                        ForEach(manager.allTags, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    Toggle("Reminder", isOn: $reminder)
                    if reminder {
                        DatePicker("Remind me", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }

                Section {
                    Button("Add Task") {
                        let task = ToDoItem(title: title, tag: selectedTag, reminderDate: reminder ? reminderDate : nil)
                        manager.add(task)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
