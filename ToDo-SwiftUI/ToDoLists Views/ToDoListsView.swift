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
    
    @State private var showingModal: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                ScrollView {
                    
                    VStack {
                        
                        Divider()
                        
                        ForEach(self.lists.indices, id: \.self) { listID in
                            
                            // MARK: Call ListsCellView
                            ListsCellView(list: self.$lists[listID])
                        }
                        
                        Spacer()
                        
                        if self.lists.isEmpty {
                            
                            
                            
                            Text("No Lists Found")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                        }
                    }
                    .navigationBarTitle(Text("ToDo Lists"),
                                        displayMode: .automatic)
                }
                    
                .sheet(isPresented: self.$showingModal) {
                    
                    // MARK: Call ListsDetailView
                    ListsDetailsView(list: self.$lists[self.lists.underestimatedCount-1],
                                     showModal: self.$showingModal)
                    
                }
                
                FloatingActionButton(systemImageName: "plus", fontSize: 20,
                                     action: {
                                        
                                        withAnimation { self.lists.append(ToDoList()) }
//                                        self.showingModal.toggle()
                })
                    .position(x: UIScreen.main.bounds.midX * 1.70,
                              y: UIScreen.main.bounds.maxY * 0.77)
            }
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
