//
//  IntentHandler.swift
//  DynamicListSelectionIntent
//
//  Created by Saumil Shah on 8/17/20.
//

import Intents

class IntentHandler: INExtension, DynamicListSelectorIntentHandling {
    
    
    func provideSelectedListOptionsCollection(for intent: DynamicListSelectorIntent, with completion: @escaping (INObjectCollection<ToDoListType>?, Error?) -> Void) {
        
        print("\n\t\t👀Inside provideSelectedListOptionsCollection at \(loggingDateFormatter.string(from: Date())) ⏰")
        
        // Iterate the available characters, creating
        // a ToDoListType for each one.
        let remoteLists: [ToDoListType] = loadListsData(usersListsDataFileName).map { list in
            
            let todoList = ToDoListType(identifier: list.getURL().absoluteString, display: list.todoListName,
                                        pronunciationHint: list.todoListName + " hint to speak",
                                        subtitle: list.todoListIcon, image: nil)
            
            return todoList
        }
            
        // Call the completion handler, passing the collection.
        let collection = INObjectCollection(items: remoteLists)
        
        completion(collection, nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
