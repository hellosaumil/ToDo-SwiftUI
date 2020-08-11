//
//  ToDo_SwiftUIApp.swift
//  Shared
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI
import UIKit
@main
struct ToDo_SwiftUIApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserData())
        }
    }
}
