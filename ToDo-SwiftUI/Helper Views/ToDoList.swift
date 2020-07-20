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
    
    var progress: CGFloat
    var isMyFavorite: Bool
    
    init(icon: String = "🍩", name: String = "New ToDo List", tasks: [ToDoTask] = [], isFav: Bool = false) {
        
        self.todoListID = UUID()
        
        self.todoListIcon = icon
        self.todoListName = name
        self.todoTasks = tasks
        
        self.progress = 0
        self.isMyFavorite = isFav
    }
    
    // MARK: Update Progress
    mutating func updateProgress(by inc: CGFloat = 10) {
        
        if (self.progress + inc) <= 100 {
            self.progress += inc
        } else {
            self.progress = 0
        }
    }
}
