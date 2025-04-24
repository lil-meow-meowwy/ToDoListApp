//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Kristina Yaroshenko on 24.04.2025.
//

import Foundation

struct ToDoItem:Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
    var tag:String="General"
    var reminderDate:Date?=nil
}
