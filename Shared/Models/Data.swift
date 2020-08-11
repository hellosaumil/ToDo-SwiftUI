//
//  Data.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI
import Foundation

// MARK: Sample Data

var someTask = ToDoTask(name: "want to-do something")

let taskItems: [String] = ["Swift Deep Dive", "What's new in SwiftUI",
                           "App Essentials in SwiftUI", "Unsafe Swift",
                           "Widets Code-along", "Swan's Quest"]


let randomTasks: [ToDoTask] = taskItems.map { ToDoTask(name: $0) }

let sampleTasksLite: [ToDoTask] = [
    ToDoTask(),
    ToDoTask(name: "Practice iOS Development",
             dueDateTime: Date()+2,
             shape: .triangle,
             
             gradientScheme: .linear,
             gradientStartColor: .pink,
             gradientEndColor: .purple,
             
             notes: "Follow 100 Days of SwiftUI", isFav: true)
]



let toDoListLite: ToDoList = ToDoList(icon: "☕️", name: "New Watchlist", tasks: [])
var toDoListRandom: ToDoList = ToDoList(icon: "👨🏻‍💻", name: "WWDC Watchlist", tasks: randomTasks)


let listIcons: [String] = ["🍕", "💼", "🐛"]
let listItems: [String] = ["Favorite Pizza Places",
                           "Target Companies", "Books to Read"]

let randomLists: [ToDoList] = [toDoListRandom] + zip(listIcons, listItems).map { ToDoList(icon: $0, name: $1) }

// MARK: User Data from Database
let userLists: [ToDoList] = [toDoListRandom] + listItems.map { ToDoList(name: $0) }



// MARK: Data/File Handling Functions

enum DataLoadSaveError: Error{
    case fileNotFound, coudlNotLoadFromBundle, coudlNotSaveToBundle, coudlNotParse
}


//
// Original Code of the load function has been modified.
//
// load function used from the following url:
// https://developer.apple.com/tutorials/swiftui/creating-and-combining-views
//
//
func loadFromBundle<T: Decodable>(_ filename: String, _ fileExtension:String? = nil, as type: T.Type = T.self) throws -> T {
    let data: Data
    let loadedData: T
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: fileExtension)
        else {
            print("Load: Couldn't find \(filename) in main bundle.")
            throw DataLoadSaveError.fileNotFound
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        print("Load: Couldn't load \(filename) from main bundle:\n\(error)")
        throw DataLoadSaveError.coudlNotLoadFromBundle
    }
    
    do {
        let decoder = JSONDecoder()
        loadedData = try decoder.decode(T.self, from: data)
    } catch {
        print("Load: Couldn't parse \(filename) as \(T.self):\n\(error)")
        throw DataLoadSaveError.coudlNotParse
    }
    
    return loadedData
}
