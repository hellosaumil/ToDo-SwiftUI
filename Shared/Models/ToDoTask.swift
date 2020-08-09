//
//  ToDoTask.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import Foundation
import SwiftUI
import Combine

class ToDoTask: Identifiable, Equatable, Hashable, ObservableObject {
    
    static func == (lhs: ToDoTask, rhs: ToDoTask) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine( id  )
    }
    
    @Published var id = UUID()
    
    @Published var todoName: String
    
    @Published var dueDateTime: Date
    
    @Published var todoShape:BaseShapes
    
    @Published var todoGradientScheme: GradientTypes
    @Published var todoGradientStartColor: BaseColors
    @Published var todoGradientEndColor: BaseColors
    
    @Published var notes: String
    @Published var isMyFavorite:Bool
    
    @Published var isCompleted: Bool = false
    
    init(name: String = "New ToDo", dueDateTime: Date = Date(),
         
         shape: BaseShapes = BaseShapes.allCases.randomElement()!,
         
         gradientScheme: GradientTypes = GradientTypes.allCases.randomElement()!,
         gradientStartColor: BaseColors = BaseColors.allCases.randomElement()!,
         gradientEndColor: BaseColors = BaseColors.allCases.randomElement()!,
         
         notes: String = "", isFav: Bool = false) {
        
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

var customMiniDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "E, MMM d B"
    return formatter
}


enum BaseColors: String, CaseIterable, Identifiable, Codable {
    
    case pink, yellow, orange, green, blue, purple
    var id: String { rawValue }
    
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
    var id: String { rawValue }
    
    var unfilled:Image { return Image(systemName: "\(id)") }
    var filled:Image { return Image(systemName: "\(id).fill") }
}
