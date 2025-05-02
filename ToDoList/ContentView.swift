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
    @State private var showNewTagField = false
    @State private var newTag = ""
    @State private var tagToDelete: String?
    @State private var showDeleteAlert = false

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
                    HStack(spacing: 8) {
                        Button("All") {
                            selectedTag = "All"
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(selectedTag == "All" ? Color.accentColor.opacity(0.2) : Color.clear)
                        .cornerRadius(10)

                        ForEach(manager.allTags, id: \.self) { tag in
                            Text(tag)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(selectedTag == tag ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.15))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedTag = tag
                                }
                                .onLongPressGesture {
                                    tagToDelete = tag
                                    showDeleteAlert = true
                                }
                        }

                        // New tag input
                        if showNewTagField {
                            HStack {
                                TextField("New tag", text: $newTag)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 120)

                                Button(action: {
                                    let trimmed = newTag.trimmingCharacters(in: .whitespaces)
                                    if !trimmed.isEmpty && !manager.allTags.contains(trimmed) {
                                        manager.allTags.append(trimmed)
                                        selectedTag = trimmed
                                    }
                                    newTag = ""
                                    showNewTagField = false
                                }) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }

                                Button(action: {
                                    newTag = ""
                                    showNewTagField = false
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        } else {
                            Button(action: {
                                showNewTagField = true
                            }) {
                                Label("Add Tag", systemImage: "plus.circle")
                                    .labelStyle(IconOnlyLabelStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                }


                
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
        .alert("Delete Tag?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let tag = tagToDelete {
                    manager.allTags.removeAll { $0 == tag }

                    // Optional: Also remove the tag from existing tasks
                    manager.tasks = manager.tasks.map {
                        var task = $0
                        if task.tag == tag {
                            task.tag = "General" // or ""
                        }
                        return task
                    }

                    if selectedTag == tag {
                        selectedTag = "All"
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete the tag \"\(tagToDelete ?? "")\"?")
        }

    }
}

