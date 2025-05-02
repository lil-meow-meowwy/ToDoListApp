//
//  TaskRow.swift
//  ToDoList
//
//  Created by Kristina Yaroshenko on 24.04.2025.
//

import SwiftUI

struct TaskRow: View{
    @State var task: ToDoItem
    @ObservedObject var manager: TaskManager
    @State private var showEdit = false
    
    var body: some View{
        HStack {
            // Checkbox for marking task as done
            Button(action: {
                task.isDone.toggle()
            }) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .gray)
                    .imageScale(.large)
            }
            
            VStack(alignment: .leading) {
                if task.isDone {
                    // If the task is marked as done, we show a faded and struck-through version
                    Text(task.title)
                        .strikethrough(true, color: .gray)
                        .foregroundColor(.gray)
                        .opacity(0.6) // Optional: make it even more faded
                } else {
                    // If the task is not done, show the title normally
                    Text(task.title)
                        .foregroundColor(.primary)
                }
                
                if let dueDate = task.reminderDate {
                    Text("Due: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                manager.toggle(task)
            }
        }
        .onLongPressGesture {
            showEdit = true
        }
        .sheet(isPresented: $showEdit){
            EditTaskView(task: Binding(get: {
                task
            }, set: {newValue in
                if let index = manager.tasks.firstIndex(where: {$0.id == newValue.id}){
                    manager.tasks[index] = newValue
                    manager.scheduleNotification(for: newValue)
                }
                task = newValue
            }), tags: manager.allTags)
        }
    }
}
