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
                
                || RandomEmoji(from: list.todoListIcon).name.lowercased().contains( query.lowercased() )
                
                || query == ""
        }
    }
    
    func update(from newLists: [ToDoList]) {
        self.todoLists = newLists
    }
    
    func listFromName(name: String?) -> ToDoList? {
        return self.todoLists.first(where: { $0.todoListName == name })
    }
    
    func listFromURL(url: URL?) -> ToDoList? {
        return self.todoLists.first(where: { $0.getURL() == url })
    }
    
    func listFromURL(name: String?) -> ToDoList? {
        
        guard let validName = name else { return nil }
        
        return self.todoLists.first(where: { $0.getURL() == URL(string: validName) })
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
    
    @Published var todoListURL: URL
    
    
    var tasksCompleted: Int {
        self.todoTasks.filter { $0.isCompleted }.count
    }
    
    var tasksPending: Int {
        self.todoTasks.filter { !$0.isCompleted }.count
    }
    
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
        
        self.todoListURL = URL(string: "todo:///init")!
        
        self.updateProgress()
        self.updateURL()
    }
    
    // MARK: Generate and Update List URL
    func generateURL() -> URL {
        
        let baseURL = "todo:///"
        
        let nameURL = self.todoListName.lowercased().strip
            .removeWhitespaces()
            .replacingOccurrences(of: " ", with: "-")
        
        let urlString = baseURL + ((nameURL == "") ? "init-none" : nameURL )
        
        return URL(string: urlString) ?? URL(string: baseURL + "init-none")!
    }
    
    func updateURL() { self.todoListURL = generateURL() }
    func getURL() -> URL { return self.todoListURL }
    
    
    // MARK: Update Progress
    func updateProgress() {
        
        if !todoTasks.isEmpty {
            self.progress = CGFloat(self.tasksCompleted) / CGFloat(todoTasks.count) * 100
        }
    }
    
    func resetProgress() {
        self.progress = 0
    }
    
    func isAllComplete() -> Bool {
        
        guard !todoTasks.isEmpty else {
            return false
        }
        
        return tasksCompleted < todoTasks.count
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
        
        case todoListIcon="icon", todoListName="name", todoListURL="url"
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
        
        todoListURL = try values.decode(URL.self, forKey: .todoListURL)
        
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
        
        try container.encode(todoListURL, forKey: .todoListURL)
        
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
