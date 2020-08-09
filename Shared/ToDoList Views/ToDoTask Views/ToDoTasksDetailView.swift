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
                        
                        ForEach(toDoList.todoTasks, id: \.self) { tasks in
                            
                            // MARK: Call ToDoTaskCellView
                            ToDoTaskCellView(task: tasks)
                                .padding(.trailing, -16)
                        }
                        .onDelete { (IndexSet) in
                            toDoList.todoTasks.remove(atOffsets: IndexSet)
                        }
                    }
                    .padding(.trailing)
                    .listStyle(PlainListStyle())
                }
            }
        }
        .navigationBarTitle(Text("\(toDoList.todoListIcon) \(toDoList.todoListName)"),
                            displayMode: .automatic)
        
        .navigationBarItems(trailing:
                                
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        toDoList.todoTasks.append(ToDoTask())
                                        // showingModal = true
                                    }
                                    
                                }, label: {
                                    Text("+ New Task")
                                        .font(.headline)
                                        .foregroundOverlay(myGradient(type: .linear, colors: [.pink, .purple]))
                                })
        )
        
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
            
            ForEach( [toDoListLite, toDoListLite2, toDoListRandom], id: \.id ) { list in
                
                NightAndDay {
                    
                    ToDoTasksDetailView(toDoList: list)
                }
            }
        }
    }
}
