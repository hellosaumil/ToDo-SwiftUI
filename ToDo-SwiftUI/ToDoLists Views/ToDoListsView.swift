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
    @State private var showingDelete: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if self.lists.isEmpty {
                    
                    Spacer()
                    
                    Text("No Lists Found")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        
                        Divider()
                        
                        ForEach(self.lists.indices, id: \.self) { listID in
                            
                            HStack {
                                
                                if self.showingDelete {
                                    
                                    getSystemImage(name: "minus.circle.fill", color: .red)
                                        .padding(.horizontal, -4)
                                        .padding(.trailing, -20)
                                        .onTapGesture { withAnimation(.easeInOut) { () -> () in
                                            if !self.lists.isEmpty { self.lists.remove(at: listID) }
                                            }}
                                }
                                
                                // MARK: Call ListsCellView
                                ListsCellView(list: self.$lists[listID]).tag(listID).transition(AnyTransition.scale)
                                
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("ToDo Lists"),
                                displayMode: .automatic)
                
                .navigationBarItems(
                    trailing:
                    
                    HStack {
                        getSystemImage(name: "plus.circle.fill", scale: .large)
                            .foregroundOverlay(myGradient(type: .linear,
                                                          colors: [hexColor(hex: "#4facfe"),
                                                                   hexColor(hex: "#00f2fe")]))
                            .padding(.horizontal, -12)
                            .onTapGesture { withAnimation { self.lists.append(ToDoList()) } }
                        
                        getSystemImage(name: "minus.circle.fill", scale: .large)
                            .foregroundOverlay(myGradient(type: .linear,
                                                          colors: [hexColor(hex: "#ff0844"),
                                                                   hexColor(hex: "#ffb199")]))
                            .padding(.horizontal, -12)
                            .onTapGesture { withAnimation(.spring()) { self.showingDelete.toggle() } }
                    }
            )
                .sheet(isPresented: self.$showingModal) {
                    
                    // MARK: Call ListsDetailView
                    ListsDetailsView(list: self.$lists[self.lists.underestimatedCount-1],
                                     showModal: self.$showingModal)
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
