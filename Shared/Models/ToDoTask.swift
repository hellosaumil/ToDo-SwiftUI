//
//  ToDoTask.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import Foundation
import SwiftUI
import Combine

final class ToDoTask: Identifiable, Equatable, Hashable, ObservableObject {
    
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
    
    @Published var isCompleted: Bool
    
    init(name: String = "", dueDateTime: Date = Date(),
         
         shape: BaseShapes = BaseShapes.allCases.randomElement()!,
         
         gradientScheme: GradientTypes = GradientTypes.allCases.randomElement()!,
         gradientStartColor: BaseColors = BaseColors.allCases.randomElement()!,
         gradientEndColor: BaseColors = BaseColors.allCases.randomElement()!,
         
         notes: String = "", isFav: Bool = false) {
        
        self.todoName = (name == "") ? shape.name + " ToDo" : name
        
        self.dueDateTime = dueDateTime
        
        self.todoShape = shape
        
        self.todoGradientScheme = gradientScheme
        self.todoGradientStartColor = gradientStartColor
        self.todoGradientEndColor = gradientEndColor
        
        self.notes = notes
        self.isMyFavorite = isFav
        
        self.isCompleted = false
    }
}

extension ToDoTask: Decodable {
    
    // MARK: Conforming to Codable
    enum CodingKeys: String, CodingKey {
        
        case todoName="name", todoShape="shape"
        
        case dueDateTime, notes, isMyFavorite="isFav", isCompleted
        
        case gradientScheme="scheme"
        case gradientStartColor="startColor", gradientEndColor="endColor"
    }
    
    convenience init(from decoder: Decoder) throws {
        
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        todoName = try values.decode(String.self, forKey: .todoName)
        
        // MARK: TODO Reading/Writing Date Failing
        dueDateTime = try customDateFormatter.date(from: values.decode(String.self, forKey: .dueDateTime)) ?? Date(timeIntervalSince1970: TimeInterval(0))
        
        todoShape = try values.decode(BaseShapes.self, forKey: .todoShape)
        todoGradientScheme = try values.decode(GradientTypes.self, forKey: .gradientScheme)
        
        todoGradientStartColor = try values.decode(BaseColors.self, forKey: .gradientStartColor)
        todoGradientEndColor = try values.decode(BaseColors.self, forKey: .gradientEndColor)
        
        notes = try values.decode(String.self, forKey: .notes)
        isMyFavorite = try values.decode(Bool.self, forKey: .isMyFavorite)
        isCompleted = try values.decode(Bool.self, forKey: .isCompleted)
        
    }
}

extension ToDoTask: Encodable {
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(todoName, forKey: .todoName)
        
        // MARK: TODO Reading/Writing Date Failing
        try container.encode( customDateFormatter.string(from: dueDateTime) , forKey: .dueDateTime)
        
        try container.encode(todoShape, forKey: .todoShape)
        
        try container.encode(todoGradientScheme, forKey: .gradientScheme)
        
        try container.encode(todoGradientStartColor, forKey: .gradientStartColor)
        try container.encode(todoGradientEndColor, forKey: .gradientEndColor)
        
        try container.encode(notes, forKey: .notes)
        try container.encode(isMyFavorite, forKey: .isMyFavorite)
        try container.encode(isCompleted, forKey: .isCompleted)
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

var loggingDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .long
    
    return formatter
}
