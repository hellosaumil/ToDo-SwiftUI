//
//  ContentView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var allLists: AllLists
    
    var body: some View {
        
        ToDoListsView(allLists: self.allLists)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        NightAndDay {
            
            ContentView(allLists: AllLists(lists: randomLists) )

        }
    }
}
