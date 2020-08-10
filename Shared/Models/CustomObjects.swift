//
//  CustomObjects.swift
//  ToDo-SwiftUI (iOS)
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

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
    
    case triangle, rhombus, diamond, square, rectangle, hexagon,
         octagon, circle, capsule, shield
    
    var id: String { name }
    
    var name: String { rawValue.lowercased() }
    
    var unfilled:Image { return Image(systemName: "\(name)") }
    var filled:Image { return Image(systemName: "\(name).fill") }
}

