//
//  ToDoList.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import Foundation
import SwiftUI
import Combine


import Foundation

class AllLists: ObservableObject {
    @Published var todoLists: [ToDoList]
    
    convenience init() {
        
        self.init(lists: [ToDoList]() )
    }
    
    init(  lists: [ToDoList] ) {
        todoLists = lists
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
        
        if !todoTasks.isEmpty {
            self.progress = CGFloat(todoTasks.filter{ $0.isCompleted }.count) / CGFloat(todoTasks.count) * 100
        }
    }
    
    func resetProgress() {
        self.progress = 0
    }
    
    func isAllComplete() -> Bool {
        
        guard !todoTasks.isEmpty else {
            return false
        }
        
        return (todoTasks.filter{ ($0.isCompleted) }).count < todoTasks.count
    }
    
    func completeTasks() {
        
        for index in todoTasks.indices {
            todoTasks[index].isCompleted = true
        }
    }
    
    func incompleteTasks() {
        
        for index in todoTasks.indices {
            todoTasks[index].isCompleted = false
        }
    }
    
}
