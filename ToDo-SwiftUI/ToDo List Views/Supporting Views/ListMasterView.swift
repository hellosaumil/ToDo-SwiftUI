//
//  ListMasterView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/1/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListMasterView: View {
    
    @State var toDoList: ToDoList
    
    @State private var tappedTask: ToDoTask = ToDoTask(name: "none")
    
    var body: some View {
        
        ScrollView {
            
            ForEach(self.toDoList.todoTasks.indices, id: \.self) { tasksIdx in
                
                // MARK: Call ListCellView
                ListCellView(task: self.$toDoList.todoTasks[tasksIdx])
            }
            
            Spacer()
            
            if self.toDoList.todoTasks.isEmpty {
                
                Text("No Tasks Found")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()
                
            }
        }
            
        .navigationBarTitle(Text(self.toDoList.todoListName),
                            displayMode: .automatic)
    }
}

struct ListMasterView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach( [toDoListLite, toDoListLite2, toDoListRandom], id: \.todoListID ) { list in
                
                NightAndDay {
                    ListMasterView(toDoList: list)
                }
            }
        }
    }
}
