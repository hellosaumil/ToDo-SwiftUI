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
    
    var dueDateTime: Date
    
    var todoShape:BaseShapes
    
    var todoGradientScheme: GradientTypes
    var todoGradientStartColor: BaseColors
    var todoGradientEndColor: BaseColors
    
    var notes: String
    var isMyFavorite:Bool
    
    var isCompleted: Bool = false
    
    init(name: String = "New ToDo", dueDateTime: Date = Date(),
         
         shape: BaseShapes = .hexagon,
         
         gradientScheme: GradientTypes = .linear,
         gradientStartColor: BaseColors = .pink,
         gradientEndColor: BaseColors = .purple,
         
         notes: String = "", isFav: Bool = false) {
        
        self.todoID = UUID()
        self.todoName = name
        
        self.dueDateTime = dueDateTime
        
        self.todoShape = shape
        
        self.todoGradientScheme = gradientScheme
        self.todoGradientStartColor = gradientStartColor
        self.todoGradientEndColor = gradientEndColor
        
        self.notes = notes
        self.isMyFavorite = isFav
    }
}

var customDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    
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
