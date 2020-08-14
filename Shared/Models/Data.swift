//
//  Data.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI
import Foundation
import WidgetKit

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
var toDoListRandom: ToDoList = ToDoList(icon: "👨🏻‍💻", name: "WWDC Watchlist", tasks: randomTasks,
                                        gradientScheme: .linear, gradientStartColor: .pink, gradientEndColor: .purple)


let listIcons: [String] = ["🍕", "💼", "🐛"]
let listItems: [String] = ["Favorite Pizza Places",
                           "Target Companies", "Books to Read"]

let randomLists: [ToDoList] = [toDoListRandom] + zip(listIcons, listItems).map { ToDoList(icon: $0, name: $1) }

// MARK: User Data from Database
let usersListsDataFileName:String = "localLists.json"

let userLists: AllLists = AllLists()

func createDB(from lists: [ToDoList]) -> Bool {
    
    do {
        
        try saveListsData(lists)
        print("\nCreateDB Successful!! 🎉\n")
        return true
        
    } catch {
        
        print("\n*****Failed: createDataBase()******* ⚠️\n")
        return false
    }
}



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

func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: "group.io.hellosaumil.ToDo-SwiftUI.contents"
    )!
}

func loadFromAppDirectory<T: Decodable>(_ filename: String, as type: T.Type = T.self) throws -> T {
    
    let fileURL = sharedContainerURL().appendingPathComponent(filename)
    
    let data: Data
    let loadedData: T
    
    do {
        
        _ = try String(contentsOf: fileURL, encoding: .utf8)
//        print("Data Read From File : \(fileData)")
        
        do {
            
            data = try Data(contentsOf: fileURL)
            
            do {
                
                let decoder = JSONDecoder()
                loadedData = try decoder.decode(T.self, from: data)
                print("\nData Read successful from \(filename) 🧐 \nat:\(fileURL)")
                
            } catch {
                
                print("Load: Couldn't parse \(fileURL) as \(T.self).\n\(error)")
                throw DataLoadSaveError.coudlNotParse
                
            }
            
        } catch {
            
            print("Load: Couldn't load \(filename).\n\(error)")
            throw DataLoadSaveError.coudlNotLoadFromBundle
        }
        
    } catch {
        
        print("ReadError: \(error)")
        throw error
    }
    
    
    return loadedData
}

func saveAnother<T: Encodable>(_ filename: String, data: T, as type: T.Type = T.self) throws {
    
    let jsonData: Data
    let jsonString:String
    
    let fileURL = sharedContainerURL().appendingPathComponent(filename)
    
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        jsonData = try encoder.encode(data)
        
        if let validJsonString = String(data: jsonData, encoding: .utf8) {
            print("Save: jsonString: \n\(validJsonString)")
            print("Attempting to Save at: \(fileURL)...")
            
            jsonString = validJsonString
            
            do {
                
                try jsonString.write(to: fileURL, atomically: false, encoding: .utf8)
                print("\tFile Saved at: \(fileURL)")
                
            } catch {
                
                print("Save: Couldn't save \(fileURL).\n\(error)")
                throw DataLoadSaveError.coudlNotSaveToBundle
            }
            
        } else {
            print("\tSave: Couldn't convert jsonData to jsonString :\n")
            throw DataLoadSaveError.coudlNotParse
        }
        
    } catch {
        print("Save: Couldn't parse \(fileURL) as \(T.self):\n\(error)")
        throw DataLoadSaveError.coudlNotParse
    }
    
}


// MARK: TODO Figure out a way to use this
func storeUpdatedUser(_ updatedUser: UserData, debug: String = "") -> Bool {
    
    // MARK: Store Updated UserData Object
    let updatedUserData = updatedUser.currentUserLists.todoLists
    
    if debug != "" {
        print("\n\nDebug: \(debug) 💭")
    }
    
    do {
        try saveListsData(updatedUserData)
        print("\nUser Data Updated! 🎉\n\n")
        
        
        // MARK: Call reloadWidgets
        DispatchQueue.main.async { reloadWidgets() }
        

        return true
        
    } catch {
        
        print("\nError while saving updated user data\(error.localizedDescription)...⚠️\n")
        return false
    }
}

// MARK: Reload All App Widgets' Timelines
func reloadWidgets() {
    
    print("\nReloading Widgets...")
    WidgetCenter.shared.reloadTimelines(ofKind: "QuickInfoWidget")
    print("\nWidgets Reloaded.\n")
}


func storeListData(_ lists: [ToDoList], debug: String = "") -> Bool {
    
    // MARK: Store Updated UserData Object

    if debug != "" {
        print("\n\nDebug: \(debug) 💭")
    }
    
    do {
        try saveListsData(lists)
        print("\nLists Data Updated! 🎉\n\n")
        return true
        
    } catch {
        
        print("\nError while saving updated lists data\(error.localizedDescription)...⚠️\n")
        return false
    }
}


func loadListsData(_ filename: String) -> [ToDoList] {
    
    let loadedListData: [ToDoList]
    
    do {
        loadedListData = try loadFromAppDirectory(filename)
    } catch {
        loadedListData = []
    }
    
    return loadedListData
}

func saveListsData(_ allLists:[ToDoList]) throws {
    
    do {
        try saveAnother(usersListsDataFileName, data: allLists)
        print("All Lists Data Saved.\n")
        
    } catch {
        print("\tCan't Save All Lists Data...\(error)\n")
        throw error
    }
    
}

