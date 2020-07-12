//
//  ToDoListsView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/12/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ToDoListsView: View {
    
    @State var lists: [ToDoList]
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ForEach(lists, id: \.todoListID) { list in
                    
                    VStack {
                        
                        ZStack(alignment: .leading) {
                            
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .foregroundColor(.primary).colorInvert()
                                .shadow(color: Color.primary.opacity(0.20),
                                        radius: 4, x: 2, y: 4)
                            
                            NavigationLink(destination: ListMasterView(toDoList: list)) {
                                
                            HStack {
                                
                                Text(list.todoListName)
                                    .font(.system(size: 22))
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                                
                                Spacer()
                                
                                    getSystemImage(name: "chevron.right", color: Color.primary.opacity(0.35),
                                                   font: .callout, scale: .medium)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 100)
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        
                    }
                }
                
                Spacer()
                
                if self.lists.isEmpty {
                    
                    Text("No Lists Found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                }
            }
            .padding(.vertical)
            .navigationBarTitle(Text("ToDo Lists"),
                                displayMode: .automatic)
        }
    }
}

struct ToDoListsView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach([[], sampleLists], id: \.self) { lists in
                
                NightAndDay {
                    ToDoListsView(lists: lists)
                    
                }
                
            }
            
        }
    }
}
