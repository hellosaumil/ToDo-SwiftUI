//
//  ListMasterView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/1/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListMasterView: View {
    
    @Binding var toDoList: ToDoList
    
    @State private var tappedTask: ToDoTask = ToDoTask(name: "none")
    
    @State private var showingModal: Bool = false
    @State private var showingDelete: Bool = false
    
    var body: some View {
        
        VStack {
            
            if self.toDoList.todoTasks.isEmpty {
                
                Spacer()
                
                Text("No Tasks Found")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                
                Spacer()
                
            } else {
                
                ScrollView {
                    
                    Divider()
                    
                    ForEach(self.toDoList.todoTasks.indices, id: \.self) { tasksIdx in
                        
                        HStack {
                            
                            if self.showingDelete {
                                
                                getSystemImage(name: "minus.circle.fill", color: .red)
                                    .padding(.horizontal, -4)
                                    .padding(.trailing, -20)
                                    .onTapGesture { withAnimation(.easeInOut) { () -> () in
                                        if !self.toDoList.todoTasks.isEmpty { self.toDoList.todoTasks.remove(at: tasksIdx) }
                                        }}
                            }
                            
                            // MARK: Call ListCellView
                            ListCellView(task: self.$toDoList.todoTasks[tasksIdx])
                            
                        }
                    }
                    
                }
                
            }
        }
        .navigationBarTitle(Text(self.toDoList.todoListName),
                            displayMode: .automatic)
            
            .navigationBarItems(
                trailing:
                
                HStack {
                    getSystemImage(name: "plus.circle.fill", scale: .large)
                        .foregroundOverlay(myGradient(type: .linear,
                                                      colors: [hexColor(hex: "#4facfe"),
                                                               hexColor(hex: "#00f2fe")]))
                        .padding(.horizontal, -12)
                        .onTapGesture { withAnimation { self.toDoList.todoTasks.append(ToDoTask()) } }
                    
                    getSystemImage(name: "minus.circle.fill", scale: .large)
                        .foregroundOverlay(myGradient(type: .linear,
                                                      colors: [hexColor(hex: "#ff0844"),
                                                               hexColor(hex: "#ffb199")]))
                        .padding(.horizontal, -12)
                        .onTapGesture { withAnimation(.spring()) { self.showingDelete.toggle() } }
                }
        )
            .sheet(isPresented: self.$showingModal) {
                
                // MARK: Call ListDetailView
                ListDetailView(task: self.$toDoList.todoTasks[self.toDoList.todoTasks.underestimatedCount-1],
                               showModal: self.$showingModal)
        }
    }
}

struct ListMasterView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach( [toDoListLite, toDoListLite2, toDoListRandom], id: \.todoListID ) { list in
                
                NightAndDay {
                    ListMasterView(toDoList: .constant(list))
                }
            }
        }
    }
}
