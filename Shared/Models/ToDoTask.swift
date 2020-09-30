//
//  ToDoTask.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import Foundation
import SwiftUI
import Combine

protocol Notifiable {
    
    func updateDateAndNotify(dueDate: Date?)
    func notifyTask(dueDate: Date?)
}

final class ToDoTask: Identifiable, Equatable, Hashable, ObservableObject {
    
    static func == (lhs: ToDoTask, rhs: ToDoTask) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine( id  )
    }
    
    static let baseURL = "toDoTask:///"
    
    @Published var id = UUID()
    
    @Published var todoName: String
    @Published var ofList: String?
    
    @Published var dueDateTime: Date?
    
    @Published var todoShape:BaseShapes
    
    @Published var todoGradientScheme: GradientTypes
    @Published var todoGradientStartColor: BaseColors
    @Published var todoGradientEndColor: BaseColors
    
    @Published var notes: String
    @Published var isMyFavorite:Bool
    
    @Published var isCompleted: Bool
    
    @Published private var todoTaskURL: URL
    
    init(name: String = "", dueDateTime: Date? = nil,
         
         shape: BaseShapes = BaseShapes.allCases.randomElement()!,
         
         gradientScheme: GradientTypes = GradientTypes.allCases.randomElement()!,
         gradientStartColor: BaseColors = BaseColors.allCases.randomElement()!,
         gradientEndColor: BaseColors = BaseColors.allCases.randomElement()!,
         
         notes: String = "", isFav: Bool = false,
         
         ofList: String? = nil) {
        
        self.todoName = (name == "") ? shape.name.capitalized + " ToDo" : name
        
        self.dueDateTime = dueDateTime
        
        self.todoShape = shape
        
        self.todoGradientScheme = gradientScheme
        self.todoGradientStartColor = gradientStartColor
        self.todoGradientEndColor = gradientEndColor
        
        self.notes = notes
        self.isMyFavorite = isFav
        
        self.isCompleted = false
        
        self.todoTaskURL = URL(string: ToDoTask.baseURL+"init")!
        self.updateURL()
        
        self.ofList = ofList
        self.updateParentListInfo(from: ofList ?? nil)
        
        // MARK: Call updateDateAndNotify()
        self.updateDateAndNotify(dueDate: self.dueDateTime)
        
    }
    
    // MARK: Generate and Update List URL
    func generateURL() -> URL {
        
        let nameURL = self.todoName.lowercased().strip
            .removeWhitespaces()
            .replacingOccurrences(of: " ", with: "-")
        
        let urlString = ToDoTask.baseURL + ((nameURL == "") ? "init-none" : nameURL )
        
        return URL(string: urlString) ?? URL(string: ToDoTask.baseURL + "init-none")!
    }
    
    func updateURL() { self.todoTaskURL = generateURL() }
    func getURL() -> URL { return self.todoTaskURL }
    
}

extension ToDoTask: Decodable {
    
    // MARK: Conforming to Codable
    enum CodingKeys: String, CodingKey {
        
        case todoName="name", todoShape="shape"
        case ofList="ofList"
        
        case dueDateTime, notes, isMyFavorite="isFav", isCompleted
        
        case gradientScheme="scheme"
        case gradientStartColor="startColor", gradientEndColor="endColor"
    }
    
    convenience init(from decoder: Decoder) throws {
        
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        todoName = try values.decode(String.self, forKey: .todoName)
        
        // MARK: Encode ofList
        ofList = try values.decode(String?.self, forKey: .ofList)
        
        // MARK: TODO Reading/Writing Date Failing
        // dueDateTime = try values.decode(Date?.self, forKey: .dueDateTime)
        
        if let validDateString = try? values.decode(String.self, forKey: .dueDateTime) {
            dueDateTime = customDateFormatter.date(from: validDateString)
        } else {
            dueDateTime = nil
        }
        
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
        
        // MARK: Decode ofList
        try container.encode(ofList, forKey: .ofList)
        
        // MARK: TODO Reading/Writing Date Failing
        // try container.encode(dueDateTime, forKey: .dueDateTime)
        
        if let validDateTime: Date = dueDateTime {
            //            print("\tValid date for \(todoName) - \(customDateFormatter.string(from: validDateTime))🦋")
            try container.encode( customDateFormatter.string(from: validDateTime), forKey: .dueDateTime)
        } else {
            //            print("\tNil date for \(todoName)🐝")
            try container.encode(dueDateTime, forKey: .dueDateTime)
        }
        
        try container.encode(todoShape, forKey: .todoShape)
        
        try container.encode(todoGradientScheme, forKey: .gradientScheme)
        
        try container.encode(todoGradientStartColor, forKey: .gradientStartColor)
        try container.encode(todoGradientEndColor, forKey: .gradientEndColor)
        
        try container.encode(notes, forKey: .notes)
        try container.encode(isMyFavorite, forKey: .isMyFavorite)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}

// MARK: ToDoTask Notifiable Support
extension ToDoTask: Notifiable {
    
    func updateParentListInfo(from parentListName: String?) { self.ofList = parentListName }
    
    func updateDateAndNotify(dueDate: Date?) {
        self.dueDateTime = dueDate
        self.notifyTask(dueDate: dueDate)
    }
    
    internal func notifyTask(dueDate: Date?) {
        
        guard let validDate = dueDate, validDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = self.todoName
        content.subtitle = self.ofList ?? "List not assigned! ⚠️"
        content.body = "Due on \(notificationDateFormatter.string(from: validDate))" + ((self.notes.isEmpty) ? "" : "\n\(self.notes)")
        
        content.sound = UNNotificationSound.default
        
        content.userInfo = ["name": self.todoName]
        content.categoryIdentifier = "taskNotif"
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: validDate)
        dateComponents.minute = calendar.component(.minute, from: validDate)
        
        print("""
            \n\t🔔 Notification Created on...\(notificationDateFormatter.string(from: Date()))
            \t for \(customDateFormatter.string(from: validDate)) - \(self.todoName)
            """)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: self.getURL().absoluteString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
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

var notificationDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    
    return formatter
}
