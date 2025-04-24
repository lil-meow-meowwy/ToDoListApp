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
        HStack{
            Text(task.title)
            Spacer()
            if task.isCompleted{
                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
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
