//
//  ListMasterView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/1/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListMasterView: View {
    
    @ObservedObject var toDoList: ToDoList
    
    @State private var tappedTask: ToDoTask = ToDoTask(name: "none")
    
    @State private var showingModal: Bool = false
    @State private var showingDelete: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                
                if self.toDoList.todoTasks.isEmpty {
                    
                    Spacer()
                    
                    Text("No Tasks Found")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                } else {
                    
                    List {
                        
                        ForEach(self.toDoList.todoTasks, id: \.self) { tasks in
                            
                            // MARK: Call ListCellView
                            ListCellView(task: tasks)
                                .padding(.trailing, -16)
                        }
                        .onDelete { (IndexSet) in
                            self.toDoList.todoTasks.remove(atOffsets: IndexSet)
                        }
                    }
                    .padding(.trailing)
                    .listStyle(PlainListStyle())
                }
            }
        }
        .navigationBarTitle(Text(self.toDoList.todoListName),
                            displayMode: .automatic)
        
        .navigationBarItems(trailing:
                                
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        self.toDoList.todoTasks.append(ToDoTask())
                                        // self.showingModal = true
                                    }
                                    
                                }, label: {
                                    Text("+ New Task")
                                        .font(.headline)
                                        .foregroundOverlay(myGradient(type: .linear, colors: [.pink, .purple]))
                                })
        )
        
        .sheet(isPresented: self.$showingModal, onDismiss: {self.showingModal = false}) {
            
            // MARK: Call ListDetailView
            ListDetailView(task: self.toDoList.todoTasks[self.toDoList.todoTasks.underestimatedCount-1],
                           showModal: self.$showingModal)
        }
    }
}

struct ListMasterView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach( [toDoListLite, toDoListLite2, toDoListRandom], id: \.id ) { list in
                
                NightAndDay {
                    
                    ListMasterView(toDoList: list)
                }
            }
        }
    }
}
