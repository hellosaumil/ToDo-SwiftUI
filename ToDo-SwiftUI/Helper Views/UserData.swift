//
//  UserData.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/11/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import Combine
import Foundation

final class UserData: ObservableObject {
    
    let willChange = PassthroughSubject<Void, Never>()
    
    // MARK: user items
    @Published var currentUserList: [ToDoList] = userLists {
        willSet {
            willChange.send()
        }
    }
    
    
    // MARK: todo items
    @Published var someTasks:[ToDoTask] = sampleTasks {
        willSet {
            willChange.send()
        }
    }
    
    @Published var someTasksLite:[ToDoTask] = sampleTasksLite {
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
    
    @Published var someListLite2:ToDoList = toDoListLite2 {
        willSet {
            willChange.send()
        }
    }
    
    @Published var someLists:[ToDoList] = sampleLists {
        willSet {
            willChange.send()
        }
    }
    
}
