//
//  ContentView.swift
//  Shared
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userData: UserData
    @State private var searchText: String = ""
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            
            ToDoListsMasterView(allLists: userData.currentUserLists, searchText: $searchText, navigationPath: $navigationPath)
                .navigationTitle("ToDo Lists")
                .searchable(text: $searchText, prompt: "Search a list by name or icon...")
            
            Text("Choose a List to see its tasks")
                .foregroundColor(.secondary)
        }
        .onAppear {
            NotificationManager.registerNotification()
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
