//
//  EditTaskView.swift
//  ToDoList
//
//  Created by Kristina Yaroshenko on 24.04.2025.
//

import SwiftUI

struct EditTaskView: View {
    @Binding var task: ToDoItem
    var tags: [String]
    
    @State private var tempTitle: String
    @State private var tempTag: String
    @State private var hasReminder: Bool
    @State private var remonderDate: Date
    
    @Environment(\.presentationMode) var presentationMode
    
    init(task: Binding<ToDoItem>, tags: [String]){
        _task = task
        self.tags = tags
        _tempTitle = State(initialValue: task.wrappedValue.title)
        _tempTag = State(initialValue: task.wrappedValue.tag)
        _hasReminder = State(initialValue: task.wrappedValue.reminderDate != nil)
        _remonderDate = State(initialValue: task.wrappedValue.reminderDate ?? Date())
    }
    
    var body:some View{
        NavigationView{
            Form{
                TextField("Title", text: $tempTitle)
                
                Picker("Tag", selection: $tempTag){
                    ForEach(tags, id: \.self){
                        Text($0)
                    }
                }
                
                Toggle("Has Reminder", isOn: $hasReminder)
                
                if hasReminder{
                    DatePicker("Reminder Date", selection: $remonderDate, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("Edit Task")
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        task.title = tempTitle
                        task.tag = tempTag
                        task.reminderDate = hasReminder ? remonderDate : nil
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
