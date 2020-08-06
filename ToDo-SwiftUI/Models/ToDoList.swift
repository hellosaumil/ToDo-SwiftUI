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

class AllLists: ObservableObject {
    @Published var myLists: [ToDoList]
    
    convenience init() {
        
        self.init(lists: [ToDoList]() )
    }
    
    init(  lists: [ToDoList] ) {
        self.myLists = lists
    }
}


class ToDoList: Identifiable, Equatable, Hashable, ObservableObject {
    
    static func == (lhs: ToDoList, rhs: ToDoList) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine( id  )
    }
    
    @Published var id = UUID()
    
    @Published var todoListIcon: String
    @Published var todoListName: String
    
    @Published var todoTasks: [ToDoTask]
    
    @Published var todoGradientScheme: GradientTypes
    @Published var todoGradientStartColor: BaseColors
    @Published var todoGradientEndColor: BaseColors
    
    @Published var progress: CGFloat
    
    @Published var isMyFavorite: Bool
    
    init(icon: String = "🍩", name: String = "New ToDo List",
         
         tasks: [ToDoTask] = [ToDoTask](),
         
         gradientScheme: GradientTypes = .linear,
         gradientStartColor: BaseColors = .pink,
         gradientEndColor: BaseColors = .purple,
         
         isFav: Bool = false) {
        
        self.todoListIcon = icon
        self.todoListName = name
        self.todoTasks = tasks
        
        self.todoGradientScheme = gradientScheme
        self.todoGradientStartColor = gradientStartColor
        self.todoGradientEndColor = gradientEndColor
        
        self.progress = 0
        self.isMyFavorite = isFav
    }
    
    // MARK: Update Progress
    func updateProgress() {
        
        if !self.todoTasks.isEmpty {
            self.progress = CGFloat(self.todoTasks.filter{ $0.isCompleted }.count) / CGFloat(self.todoTasks.count) * 100
        }
    }
    
    func resetProgress() {
        self.progress = 0
    }
}
