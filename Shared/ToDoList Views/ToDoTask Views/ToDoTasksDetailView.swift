//
//  ToDoTasksDetailView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ToDoTasksDetailView: View {
    
    @ObservedObject var toDoList: ToDoList
    
    @State private var showingModal: Bool = false
    @State private var showingDelete: Bool = false
    
    @State private var searchText: String = ""
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                if toDoList.todoTasks.isEmpty {
                    
                    Spacer()
                    
                    Text("No Tasks Found")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                } else {
                    
                    List {
                        
                        ForEach( toDoList.filterTasks(query: searchText), id: \.self) { task in
                            
                            // MARK: Call ToDoTaskCellView
                            ToDoTaskCellView(task: task)
                                .padding(.trailing, -16)
                        }
                        .onDelete { (IndexSet) in
                            toDoList.todoTasks.remove(atOffsets: IndexSet)
                            
                            // MARK: Reload All Widgets
                            DispatchQueue.main.async {
                                userLists.saveLists()
                            }
                        }
                    }
                    .padding(.trailing)
                    .listStyle(PlainListStyle())
                }
            }
        }
        .onDisappear(perform: {
            
            // MARK: Update List Progress on Disappear
            toDoList.updateProgress()
            
            // MARK: Update Stored Lists
            DispatchQueue.main.async { userLists.saveLists() }
        })
        .navigationTitle("\(toDoList.todoListIcon) \(toDoList.todoListName)")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search a task by name or shape...")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        // MARK: Call addNewList
                        _ = toDoList.addNewTask()
                        // MARK: Update Stored Lists
                        DispatchQueue.main.async { userLists.saveLists() }
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add").font(.headline)
                    }
                    .padding(0)
                    .foregroundOverlay(myGradient(type: .linear, colors: [.pink, .purple]))
                }
            }
        }
        .sheet(isPresented: $showingModal, onDismiss: {showingModal = false}) {
            // MARK: Call ToDoTaskInfoView
            ToDoTaskInfoView(task: toDoList.todoTasks[toDoList.todoTasks.underestimatedCount-1],
                             showModal: $showingModal)
        }
    }
}

struct ToDoTasksDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach( [toDoListLite, toDoListRandom], id: \.id ) { list in
                NightAndDay {
                    ToDoTasksDetailView(toDoList: list)
                }
            }
        }
    }
}
