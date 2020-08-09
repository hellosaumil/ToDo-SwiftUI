//
//  ContentView.swift
//  Shared
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    
    @ObservedObject var lists: AllLists
    
    var body: some View {
        
        NavigationView {
            
            ToDoListsMasterView(allLists: lists)
            
            Text("Choose a List to see its tasks")
                .foregroundColor(.secondary)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(lists: AllLists(lists: randomLists))
    }
}

func authenticate(completion: @escaping ( (Bool) -> () )) {
    
    let context = LAContext()
    var error: NSError?
    
    //        let ourLAPolicy: LAPolicy = .deviceOwnerAuthenticationWith
    let ourLAPolicy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    
    
    guard context.canEvaluatePolicy(ourLAPolicy, error: &error) else {
        
        // MARK: NO Biometrics
        print("NO Biometrics on User Device. ⚠️⛔️📱")
        
        return
    }
    
    
    // MARK: Check for Biometrics
    let reason = "Need to unlock your lists or task."
    
    context.evaluatePolicy(ourLAPolicy, localizedReason: reason) { (success, authError) in
        
        DispatchQueue.main.async {
            
            if success {
                
                // MARK: Auth Successful
                print("Authenticated Successful. 🎉")
                
                completion(false)
                
            } else {
                
                // MARK: Auth Failed
                print("Authenticated FAILED with \(error?.localizedDescription ?? "user cancelled action"). ⚠️")
                
                completion(true)
            }
        }
    }
}
