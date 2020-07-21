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
    
    var body: some View {
        
        VStack {
            
            Divider()
            
            if self.toDoList.todoTasks.isEmpty {
                
                Spacer()
                
                Text("No Tasks Found")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                
                Spacer()
                
            } else {
                
                ScrollView {
                    
                    ForEach(self.toDoList.todoTasks.indices, id: \.self) { tasksIdx in
                        
                        // MARK: Call ListCellView
                        ListCellView(task: self.$toDoList.todoTasks[tasksIdx])
                    }
                    
                }
                
            }
        }
        .navigationBarTitle(Text(self.toDoList.todoListName),
                            displayMode: .automatic)
            
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
