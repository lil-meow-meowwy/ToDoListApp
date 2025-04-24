//
//  TaskManager.swift
//  ToDoList
//
//  Created by Kristina Yaroshenko on 24.04.2025.
//

import Foundation
import UserNotifications

class TaskManager: ObservableObject {
    @Published var allTags: [String] = ["General"]
    @Published var tasks: [ToDoItem] = []{
        didSet{
            saveTasks()
        }
    }
    
    let tasksKey="tasks_key"
    
    init(){
        loadTasks()
    }
    
    func add(_ task:ToDoItem){
        tasks.append(task)
        scheduleNotification(for: task)
    }
    
    func delete(at offsets:IndexSet){
        tasks.remove(atOffsets: offsets)
    }
    
    func toggle(_ task:ToDoItem){
        if let index=tasks.firstIndex(where:{ $0.id==task.id}){
            tasks[index].isCompleted.toggle()
        }
    }
    
    func scheduleNotification(for task: ToDoItem) {
        guard let date = task.reminderDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = task.title
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)
        
        let request = UNNotificationRequest(identifier:task.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to schedule notification: \(error)")
            }
        }
    }
    
    private func saveTasks(){
        if let encoded=try? JSONEncoder().encode(tasks){
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks(){
        if let data=UserDefaults.standard.data(forKey: tasksKey), let decoded=try?JSONDecoder().decode([ToDoItem].self, from: data){
            tasks=decoded
        }
    }
}
