//
//  UserData.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import Combine
import Foundation

final class UserData: ObservableObject {
    
    // MARK: Init Data Store for the App
    init() { userLists.update(from: loadListsData(usersListsDataFileName)) }
    
    let willChange = PassthroughSubject<Void, Never>()
    
    // MARK: user items
    @Published var currentUserLists: AllLists = userLists {
        willSet {
            willChange.send()
        }
    }
    
    
    // MARK: todo items
    @Published var someTasksLite:[ToDoTask] = sampleTasksLite {
        willSet {
            willChange.send()
        }
    }
    
    @Published var someRandomTasks:[ToDoTask] = randomTasks {
        willSet {
            willChange.send()
        }
    }
    
    
    //MARK: todo lists
    @Published var someListLite:ToDoList = toDoListLite {
        willSet {
            willChange.send()
        }
    }
    
    @Published var someRandomLists:[ToDoList] = randomLists {
        willSet {
            willChange.send()
        }
    }
    
}
