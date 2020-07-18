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
    
    @State private var showingModal: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.primary).colorInvert()
                    .shadow(color: Color.secondary.opacity(0.40),
                            radius: 4, x: 2, y: 4)
                
                HStack {
                    
                    // MARK: Call ToDoCellRow
                    ToDoCellRowItem(task: self.$task)
                    
                    Spacer()
                    
                    getSystemImage(name: "pencil.and.ellipsis.rectangle", color: Color.secondary.opacity(0.40),
                                   font: .callout, scale: .medium)
                        
                        .onTapGesture { self.showingModal.toggle() }
                }
            }
            .padding(.horizontal)
            .frame(height: 60)
                
            .sheet(isPresented: self.$showingModal) {
                
                // MARK: Call DetailView
                ListDetailView(task: self.$task,
                               showModal: self.$showingModal)
                    .background(self.colorScheme == .dark ? Color.black : Color.white)
                
            }
            
            // MARK: TODO Context Menu for ToDo Cell
            .contextMenu {
                
                ZStack {
                    
                    Text("Name: \(self.task.todoName)").lineLimit(4)
                    Text("Shape: \(self.task.todoShape.rawValue)")
                    Text("Due on: \( customDateFormatter.string(from: self.task.dueDateTime) )")
                }
            }
            
            Divider()
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        }
        
    }
}

var someTask = ToDoTask(name: "want to-do something")

struct ListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListCellView(task: .constant(someTask))
            .previewLayout(.sizeThatFits)
    }
}

struct ToDoCellRowItem: View {
    
    @Binding var task: ToDoTask
    
    var body: some View {
        
        HStack {
            
            getSystemImage(name: "\(self.task.todoShape)" +
                ((self.task.isCompleted) ? ".fill" : ""), color: .primary, font: .body)
                .foregroundOverlay(myGradient(type: self.task.todoGradientScheme,
                                              colors: [self.task.todoGradientStartColor.color,
                                                       self.task.todoGradientEndColor.color]))
            
            Text("\(self.task.todoName)")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .foregroundOverlay(myGradient(type: self.task.todoGradientScheme,
                                              colors: [self.task.todoGradientStartColor.color,
                                                       self.task.todoGradientEndColor.color]))
        }
        .padding(.horizontal)
            
        .onTapGesture {
            self.task.isCompleted.toggle()
        }
    }
}
