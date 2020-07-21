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
            
            VStack {
                
                Divider()
                
                if self.lists.isEmpty {
                    
                    Spacer()
                    
                    Text("No Lists Found")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        
                        ForEach(self.lists.indices, id: \.self) { listID in
                            
                            // MARK: Call ListsCellView
                            ListsCellView(list: self.$lists[listID])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("ToDo Lists"),
                                displayMode: .automatic)
                
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
