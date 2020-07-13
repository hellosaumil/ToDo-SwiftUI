//
//  ToDoList.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/11/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


import Foundation

struct ToDoList: Codable, Equatable, Hashable {
    
    let todoListID: UUID
    
    var todoListIcon: String
    var todoListName: String
    
    var todoTasks: [ToDoTask]
    
    init(icon: String = "🍩", name: String = "New ToDo List", tasks: [ToDoTask] = []) {
        
        self.todoListID = UUID()
        
        self.todoListIcon = icon
        self.todoListName = name
        self.todoTasks = tasks
    }
}
