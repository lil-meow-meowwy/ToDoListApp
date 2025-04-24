//
//  ContentView.swift
//  ToDoList
//
//  Created by Kristina Yaroshenko on 24.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var manager = TaskManager()
    @State private var searchText = ""
    @State private var selectedTag = "All"
    @State private var showingNewTaskSheet = false
    
    @State private var newTag = ""

    var filteredTasks: [ToDoItem] {
        manager.tasks.filter { task in
            (selectedTag == "All" || task.tag == selectedTag) &&
            (searchText.isEmpty || task.title.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search + Add button
                HStack {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        showingNewTaskSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                    .padding(.leading, 4)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Tag Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button("All") {
                            selectedTag = "All"
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(selectedTag == "All" ? Color.accentColor.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                        
                        ForEach(manager.allTags, id: \.self) { tag in
                            Button(tag) {
                                selectedTag = tag
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(selectedTag == tag ? Color.accentColor.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Add New Tag
                HStack {
                    TextField("New tag", text: $newTag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        let trimmed = newTag.trimmingCharacters(in: .whitespaces)
                        if !trimmed.isEmpty && !manager.allTags.contains(trimmed) {
                            manager.allTags.append(trimmed)
                            newTag = ""
                        }
                    }
                }
                .padding(.horizontal)
                
                // Task List
                List {
                    ForEach(filteredTasks) { task in
                        TaskRow(task: task, manager: manager)
                    }
                    .onDelete { indexSet in
                        withAnimation {
                            let tasksToRemove = indexSet.map { filteredTasks[$0] }
                            manager.tasks.removeAll(where: { task in
                                tasksToRemove.contains(where:{$0.id == task.id})
                            })
                        }
                    }
                }
            }
            .navigationTitle("My Tasks")
            .sheet(isPresented: $showingNewTaskSheet) {
                NewTaskView(manager: manager)
            }
        }
    }
}

