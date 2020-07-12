//
//  ContentView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var list: ToDoList
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        
        ListMasterView(toDoList: list)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        NightAndDay {
            ContentView(list: toDoListLite2)
            .environmentObject(UserData())
        }
    }
}
