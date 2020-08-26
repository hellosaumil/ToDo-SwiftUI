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
            
            Text("Choose a List to see its tasks")
                .foregroundColor(.secondary)
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
