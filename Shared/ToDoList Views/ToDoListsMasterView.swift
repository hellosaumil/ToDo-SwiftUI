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
    
    @State private var searchText: String = ""
    @State private var showingSearch: Bool = false
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                if allLists.todoLists.isEmpty {
                    
                    Spacer()
                    
                    Text("No Lists Found")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                } else {
                    
                    List  {
                        
                        ForEach( allLists.filterLists(query: searchText), id: \.self) { list in
                            
                            // MARK: Call ToDoListCellView
                            ToDoListCellView(list: list)
                                .padding(.trailing, -16)
                            
                        }
                        .onDelete { (IndexSet) in
                            allLists.todoLists.remove(atOffsets: IndexSet)
                            
                            // MARK: Reload All Widgets
                            DispatchQueue.main.async {
                                userLists.saveLists()
                            }
                        }
                    }
                    .padding(.trailing)
                    .listStyle(PlainListStyle())
                    .padding(.top, showingSearch ? 40 : 0 )
                }
            }
            
            if showingSearch && !allLists.todoLists.isEmpty  {
                
                SearchBar(message: "Search a list by name or icon...", query: $searchText, isActive: $showingSearch)
            }
            
        }
        .onDisappear(perform: {
            // MARK: Update Stored Lists onDelete
            DispatchQueue.main.async { userLists.saveLists() }
        })
        .navigationBarTitle(Text("ToDo Lists"))
        
        .navigationBarItems(leading:
                                Button(action: {
                                    
                                    withAnimation(.easeInOut) {
                                        
                                        // MARK: Call addNewList
                                        _ = allLists.addNewList()
                                        
                                        // MARK: Update Stored Lists onDelete
                                        DispatchQueue.main.async { userLists.saveLists() }
                                    }
                                    
                                }) {
                                    
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("Add").font(.headline)
                                    }
                                    .padding(0)
                                    .foregroundOverlay(myGradient(type: .linear, colors: [.pink, .purple]))
                                },
                            
                            trailing:
                                Button(action: {
                                    
                                    withAnimation(.easeInOut) {
                                        searchText = ""
                                        showingSearch.toggle() }
                                    
                                }) {
                                    
                                    HStack {
                                        Text("Search").font(.headline)
                                        Image(systemName: "magnifyingglass")
                                    }
                                    .padding(0)
                                    .foregroundOverlay(myGradient(type: .linear, colors: [.pink, .purple]))
                                    
                                }
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
