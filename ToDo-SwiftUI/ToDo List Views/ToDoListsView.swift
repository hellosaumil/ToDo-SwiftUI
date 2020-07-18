//
//  ToDoListsView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/12/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ToDoListsView: View {
    
    @Binding var lists: [ToDoList]
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ForEach(self.lists.indices, id: \.self) { listID in
                    
                    VStack {
                        
                        ZStack(alignment: .leading) {
                            
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .foregroundColor(.primary).colorInvert()
                                .shadow(color: Color.primary.opacity(0.20),
                                        radius: 4, x: 2, y: 4)
                            
                            // MARK: Call ListMasterView
                            NavigationLink(destination: ListMasterView(toDoList: self.$lists[listID])) {
                                
                                HStack {
                                    
                                    HStack(spacing: 0) {
                                        
                                        Text(self.lists[listID].todoListIcon)
                                            .font(.system(size: 26))
                                        
                                        Text(self.lists[listID].todoListName)
                                            .font(.system(size: 24))
                                            .fontWeight(.semibold)
                                            .foregroundOverlay(myGradient(type: .linear, colors: [.orange, .pink]))
                                            .padding(.horizontal)
                                    }
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
                    ToDoListsView(lists: .constant(lists))
                        .environmentObject(UserData())
                }
                
            }
            
        }
    }
}
