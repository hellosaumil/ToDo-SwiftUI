//
//  ContentView.swift
//  Shared
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        
        NavigationView {
            
            ToDoListsMasterView(allLists: userData.currentUserLists)
                .onAppear( perform: { _ = storeUpdatedUser(userData, debug: "onAppear") } )
                .onDisappear( perform: { _ = storeUpdatedUser(userData, debug: "onDisappear") } )
            
            Text("Choose a List to see its tasks")
                .foregroundColor(.secondary)
        }
        .onAppear {
            // Check for the last selected ToDoList.
            if let list = AllLists.getLastSelectedList() {
                print("Last list selection: \(list.todoListName)")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        NightAndDay {
            ContentView()
                .environmentObject(UserData())
        }
    }
}
