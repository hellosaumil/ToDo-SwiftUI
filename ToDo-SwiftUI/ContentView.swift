//
//  ContentView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        
        ToDoListsView(lists: self.$userData.someRandomLists)
        
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
