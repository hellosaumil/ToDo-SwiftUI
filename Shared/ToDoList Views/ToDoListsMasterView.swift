//
//  ToDoListsMasterView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ToDoListsMasterView: View {
    
    @ObservedObject var allLists: AllLists
    
    @State private var showingModal: Bool = false
    @State private var showingDelete: Bool = false
    
    var body: some View {
        
        VStack {
            
            if allLists.todoLists.isEmpty {
                
                Spacer()
                
                Text("No Lists Found")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                
                Spacer()
                
            } else {
                
                List  {
                    
                    ForEach(allLists.todoLists, id: \.self) { list in
                        
                        // MARK: Call ToDoListCellView
                        ToDoListCellView(list: list)
                        
                    }
                    .onDelete { (IndexSet) in
                        allLists.todoLists.remove(atOffsets: IndexSet)
                    }
                }
                .padding(.trailing)
                .listStyle(PlainListStyle())
            }
        }
        
        .navigationBarTitle(Text("ToDo Lists"),
                            displayMode: .automatic)
        
        .navigationBarItems(trailing:
                                
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        allLists.todoLists.append(ToDoList())
                                        // showingModal = true
                                    }
                                    
                                }, label: {
                                    Text("+ New List")
                                        .font(.headline)
                                        .foregroundOverlay(myGradient(type: .linear, colors: [.pink, .purple]))
                                })
        )
        
        .sheet(isPresented: $showingModal, onDismiss: {showingModal = false}) {
            
            
            // MARK: Call ToDoListInfoView
            ToDoListInfoView(list: allLists.todoLists[allLists.todoLists.count-1],
                             showModal: $showingModal)
        }
    }
}

struct ToDoListsMasterView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach([ [], randomLists ], id: \.self) { lists  in
            
            //            NightAndDay {
            ToDoListsMasterView(allLists: AllLists(lists: lists))
            //            }
        }
    }
}
