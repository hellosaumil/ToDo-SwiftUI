//
//  ToDoTask.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/9/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


import Foundation

struct ToDoTask: Codable, Equatable, Hashable {
    
    let todoID: UUID
    var todoName: String
    
    var dueDate: Date
    var dueTime: Date
    
    var todoColor:BaseColors
    var todoShape:BaseShapes
    
    var isMyFavorite:Bool
    
    init(name: String, dueDate: Date, dueTime: Date,
         color: BaseColors, shape: BaseShapes,
         isFav: Bool) {
        
        self.todoID = UUID()
        self.todoName = name
        
        self.dueDate = dueDate
        self.dueTime = dueTime
        
        self.todoColor = color
        self.todoShape = shape
        
        self.isMyFavorite = isFav
    }
    
    init() {
        
        self.init(name: "New ToDo", dueDate: Date(), dueTime: Date(),
                  color: .green, shape: .shield, isFav: false)
        
    }
}

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}

enum BaseColors: String, CaseIterable, Identifiable, Codable {
    
    case pink, yellow, orange, green, blue, purple
    var id: String { self.rawValue }
    
    var color: Color {
        
        switch self {
            
        case .pink: return .pink
        case .yellow: return .yellow
        case .orange: return .orange
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
            
        }
    }
}

enum BaseShapes: String, CaseIterable, Identifiable, Codable {
    
    case triangle, square, rectangle, hexagon, circle, capsule, shield
    var id: String { self.rawValue }
    
    var unfilled:Image { return Image(systemName: "\(self.id)") }
    var filled:Image { return Image(systemName: "\(self.id).fill") }
}
