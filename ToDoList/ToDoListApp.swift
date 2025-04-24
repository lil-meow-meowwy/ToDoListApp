//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Kristina Yaroshenko on 24.04.2025.
//

import SwiftUI
import UserNotifications

@main
struct ToDoListApp: App {
    init(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){granted, error in
            if granted{
                print("Notification permission is granted.")
            }else{
                print("Notification permission is denied.")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
