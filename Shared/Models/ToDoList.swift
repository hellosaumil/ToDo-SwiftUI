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
    
    init( lists: [ToDoList] ) {
        todoLists = lists
    }
    
    func filterLists(query: String) -> [ToDoList] {
        
        return todoLists.filter { list in
            list.todoListName.lowercased().contains( query.lowercased() )
                || list.todoListIcon.lowercased().contains( query.lowercased() )
                || query == ""
        }
    }
    
    func update(from newLists: [ToDoList]) {
        self.todoLists = newLists
    }
}

enum iconPresets: String, CaseIterable, Codable {
    case 👨🏻‍💻, 🍩, 📱, 🍕, 🌊, 🏀, 📚, 🏔, 🥂, 🍟
    var id: String { name }
    var name: String { rawValue.lowercased() }
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    
    func getFirst() -> String {
        
        guard self != "" else {
            return self
        }
        
        return String(self.strip[self.strip.index(before: startIndex)])
    }
    
    func getLast() -> String {
        
        guard self.strip != "" else {
            return ""
        }
        
        return String(self.strip[self.strip.index(before: endIndex)])
    }
    
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

}

struct RandomEmoji {
    
    var emoji: String = ""
    var name: String = ""
    
    init(from icon: String = "", default defaultName: String = "random emoji", suffix: String = "") {
        
        self.emoji = icon.containsOnlyEmoji ? icon : getRandomEmoji()
        self.name = getEmojiName(of: emoji, default: defaultName, suffix: suffix)
    }
    
    private func getRandomEmoji() -> String {
        return String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
    }
    
    private func getEmojiName(of icon: String, default defaultName: String = "NoName", suffix: String = "") -> String {
        
        var emojiName: String? = icon
        
        for scalar in self.emoji.unicodeScalars {
            emojiName = (scalar.properties.name?.capitalized ?? defaultName)
        }
        
        return (emojiName ?? defaultName) + (suffix == "" ? suffix : " "+suffix )
    }
}


final class ToDoList: Identifiable, Equatable, Hashable, ObservableObject {
    
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
    
    @Published var isLocked: Bool
    
    init(icon: String = "", name: String = "",
         
         tasks: [ToDoTask] = [ToDoTask](),
         
         gradientScheme: GradientTypes = GradientTypes.allCases.randomElement()!,
         gradientStartColor: BaseColors = BaseColors.allCases.randomElement()!,
         gradientEndColor: BaseColors = BaseColors.allCases.randomElement()!,
         
         isFav: Bool = false) {
        
        let emojiObj = RandomEmoji(from: icon.getLast(), default: "ToDo", suffix: "List")
        
        self.todoListIcon = emojiObj.emoji
        self.todoListName = (name == "") ? emojiObj.name : name
        
        self.todoTasks = tasks
        
        self.todoGradientScheme = gradientScheme
        self.todoGradientStartColor = gradientStartColor
        self.todoGradientEndColor = gradientEndColor
        
        self.progress = 0
        self.isMyFavorite = isFav
        
        self.isLocked = false
        
        self.updateProgress()
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
    
    
    // MARK: Filter Tasks
    func filterTasks(query: String) -> [ToDoTask] {
        
        return todoTasks.filter { task in
            task.todoName.lowercased().contains( query.lowercased() )
                || task.todoShape.name.contains( query.lowercased() )
                || query == ""
        }
    }
}

extension ToDoList: Decodable {
    
    // MARK: Conforming to Codable
    enum CodingKeys: String, CodingKey {
        
        case todoListIcon="icon", todoListName="name"
        case todoTasks="tasks"
        
        case progress, isMyFavorite="isFav", isLocked
        
        case gradientScheme="scheme"
        case gradientStartColor="startColor", gradientEndColor="endColor"
    }
    
    
    convenience init(from decoder: Decoder) throws {
        
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        todoListIcon = try values.decode(String.self, forKey: .todoListIcon)
        todoListName = try values.decode(String.self, forKey: .todoListName)
        
        todoTasks = try values.decode([ToDoTask].self, forKey: .todoTasks)
        
        todoGradientScheme = try values.decode(GradientTypes.self, forKey: .gradientScheme)
        todoGradientStartColor = try values.decode(BaseColors.self, forKey: .gradientStartColor)
        todoGradientEndColor = try values.decode(BaseColors.self, forKey: .gradientEndColor)
        
        progress = try values.decode(CGFloat.self, forKey: .progress)
        isMyFavorite = try values.decode(Bool.self, forKey: .isMyFavorite)
        isLocked = try values.decode(Bool.self, forKey: .isLocked)
        
        self.updateProgress()
    }
    
}

extension ToDoList: Encodable {
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(todoListIcon, forKey: .todoListIcon)
        try container.encode(todoListName, forKey: .todoListName)
        
        try container.encode(todoTasks, forKey: .todoTasks)
        
        try container.encode(todoGradientScheme, forKey: .gradientScheme)
        
        try container.encode(todoGradientStartColor, forKey: .gradientStartColor)
        try container.encode(todoGradientEndColor, forKey: .gradientEndColor)
        
        try container.encode(progress, forKey: .progress)
        try container.encode(isMyFavorite, forKey: .isMyFavorite)
        try container.encode(isLocked, forKey: .isLocked)
    }
}


extension AllLists {
 
    func saveLists() {
        
        do {
            
            try saveListsData(self.todoLists)
            
        } catch {
            
            print("\n*****Failed: saveLists()*******\n")
        }
    }
    
}
