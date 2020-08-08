//
//  ContentView.swift
//  Shared
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var lists: AllLists
    
    var body: some View {
        
        NavigationView {
        
            ToDoListsMasterView(allLists: lists)

            Text("Choose a List to see its tasks")
                .foregroundColor(.secondary)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(lists: AllLists(lists: randomLists))
    }
}
