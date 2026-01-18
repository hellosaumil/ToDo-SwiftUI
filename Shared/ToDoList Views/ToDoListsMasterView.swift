//
//  ToDoListsMasterView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ToDoListsMasterView: View {
    
    @ObservedObject var allLists: AllLists
    @Binding var searchText: String
    @Binding var navigationPath: NavigationPath
    
    @State private var showingModal: Bool = false
    @State private var showingDelete: Bool = false
    
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
                            
                            // Use ZStack to hide NavigationLink disclosure indicator
                            ZStack {
                                // Hidden NavigationLink for navigation
                                NavigationLink(value: list) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                // Visible cell content
                                ToDoListCellView(list: list, navigationPath: $navigationPath)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            
                        }
                        .onDelete { (IndexSet) in
                            allLists.todoLists.remove(atOffsets: IndexSet)
                            
                            // MARK: Reload All Widgets
                            DispatchQueue.main.async {
                                userLists.saveLists()
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationDestination(for: ToDoList.self) { list in
                        ToDoTasksDetailView(toDoList: list)
                    }
                }
            }
        }
        .onDisappear(perform: {
            // MARK: Update Stored Lists
            DispatchQueue.main.async { userLists.saveLists() }
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { NotificationManager.sampleNotification() }) {
                    Image(systemName: "bell.badge")
                        .foregroundColor(.secondary)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        _ = allLists.addNewList()
                        DispatchQueue.main.async { userLists.saveLists() }
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add").font(.headline)
                    }
                    .foregroundOverlay(myGradient(type: .linear, colors: [.pink, .purple]))
                }
            }
        }
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
            ToDoListsMasterView(allLists: AllLists(lists: lists), searchText: .constant(""), navigationPath: .constant(NavigationPath()))
        }
    }
}
