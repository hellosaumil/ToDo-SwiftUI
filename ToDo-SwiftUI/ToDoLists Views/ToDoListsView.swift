//
//  ToDoListsView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/12/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ToDoListsView: View {
    
    @ObservedObject var allLists: AllLists
    
    @State private var showingModal: Bool = false
    @State private var showingDelete: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                VStack {
                    
                    if self.allLists.myLists.isEmpty {
                        
                        Spacer()
                        
                        Text("No Lists Found")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                    } else {
                        
                        List  {
                            
                            ForEach(self.allLists.myLists, id: \.self) { list in
                                
                                // MARK: Call ListsCellView
                                ListsCellView(list: list)
                                
                            }
                            .onDelete { (IndexSet) in
                                self.allLists.myLists.remove(atOffsets: IndexSet)
                            }
                        }
                        .padding(.trailing)
                        .listStyle(PlainListStyle())
                    }
                }
                
                FloatingActionButton(action: {
                    withAnimation(.easeInOut) {
                        self.allLists.myLists.append(ToDoList())
//                        self.showingModal = true
                    }
                })
            }
            .navigationBarTitle(Text("ToDo Lists"),
                                displayMode: .automatic)
            
                .sheet(isPresented: self.$showingModal, onDismiss: {self.showingModal = false}) {
                    
                    
                    // MARK: Call ListsDetailView
                    ListsDetailsView(list: self.allLists.myLists[self.allLists.myLists.count-1],
                                     showModal: self.$showingModal)
            }
        
        
        }
    }
}

struct ToDoListsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NightAndDay {
            ToDoListsView(allLists: AllLists(lists: sampleLists) )
        }
    }
}


