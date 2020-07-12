//
//  ListCellView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/1/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListCellView: View {
    
    @Binding var task: ToDoTask
    @Binding var showingModal: Bool
    
    var body: some View {
        
        HStack {
            
            getSystemImage(name: "\(self.task.todoShape)" +
                ((self.task.isCompleted) ? ".fill" : ""),
                           color: self.task.todoColor.color, font: .body)
                .foregroundOverlay(myGradient(type: .linear,
                                              colors: [.red, .purple]))
            
            Text("\(self.task.todoName)")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .foregroundOverlay( myGradient(type: .linear) )
        }
        .padding(.horizontal)
            
        .foregroundColor(self.task.todoColor.color)
            
        .onTapGesture { self.task.isCompleted.toggle() }
            
        .sheet(isPresented: self.$showingModal) {
            
            ListDetailView(task: self.$task,
                           showModal: self.$showingModal)
                .accentColor(.green)
        }
    }
}

var someTask = ToDoTask(name: "want to-do something")

struct ListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListCellView(task: .constant(someTask),
                     showingModal: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
