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
