//
//  BiometricsAuthentication.swift
//  ToDo-SwiftUI (iOS)
//
//  Created by Saumil Shah on 8/8/20.
//

import Foundation
import LocalAuthentication

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
