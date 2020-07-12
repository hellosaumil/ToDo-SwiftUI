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
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ForEach(self.toDoList.todoTasks, id: \.self) { task in
                    
                    VStack {
                        
                        ZStack(alignment: .leading) {
                            
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .foregroundColor(.primary).colorInvert()
                                .shadow(color: Color.primary.opacity(0.20),
                                        radius: 4, x: 2, y: 4)
                            
                            HStack {
                                
                                ListCellView(item: task.todoName)
                                
                                Spacer()
                                
                                NavigationLink(destination: ListDetailView(todoTask: task)) {
                                    
                                    getSystemImage(name: "chevron.right", color: Color.primary.opacity(0.35),
                                                   font: .callout, scale: .medium)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(height: 60)
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        
                    }
                }
                
                
                Spacer()
                
                Text("No Tasks Found")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.vertical)
            .navigationBarTitle(Text(self.toDoList.todoListName),
                                displayMode: .automatic)
        }
    }
}

struct ListMasterView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            NightAndDay {
                
                ListMasterView(toDoList: toDoListLite)
                
            }
            
            NightAndDay {
                ListMasterView(toDoList: toDoListLite2)
            }
            
        }
        
    }
}
