//
//  ListCellView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/1/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListCellView: View {
    
    @ObservedObject var task: ToDoTask
    @State private var moreInfoTapped: Bool = false
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                if self.moreInfoTapped {
                    ZStack(alignment: .center) {
                        
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color.secondary.opacity(0.10))
                            .frame(height: 20).offset(y: 8)
                        
                        // MARK: Call TaskEditBarView
                        TaskEditBarView(task: self.task)
                        
                    }
                    .frame(height: 40)
                    .offset(y: (moreInfoTapped) ? 36 : 0)
                }
                
                ZStack(alignment: .leading) {
                    
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundColor(.primary).colorInvert()
                        .shadow(color: Color.secondary.opacity(0.40),
                                radius: 4, x: 0, y: 4)
                    
                    // MARK: Call ToDoCellRow
                    ToDoCellRowItem(task: self.task)
                }
                .frame(height: 60)
                .onTapGesture {
                    
                    withAnimation(.interactiveSpring(response: 0.40, dampingFraction: 0.86, blendDuration: 0.25)) { self.moreInfoTapped.toggle() }
                }
                    
                    // MARK: TODO Context Menu for ToDo Cell
                    .contextMenu {
                        
                        Text("Name: \(self.task.todoName)").lineLimit(4)
                        Text("Shape: \(self.task.todoShape.rawValue)")
                        Text("Due on: \( customDateFormatter.string(from: self.task.dueDateTime) )")
                }
                
            }
            .padding()
            .padding(.bottom, (moreInfoTapped) ? 20 : 0)
            
            Divider()
                .padding(.horizontal, 16)
        }
        
    }
}

var someTask = ToDoTask(name: "want to-do something")

struct ListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListCellView(task: someTask)
            .previewLayout(.sizeThatFits)
    }
}

struct ToDoCellRowItem: View {
    
    @ObservedObject var task: ToDoTask
    
    var body: some View {
        
        HStack {
            
            // MARK: Complete Task
            getSystemImage(name: "\(self.task.todoShape)" +
                ((self.task.isCompleted) ? ".fill" : ""), color: .primary,
                                                          fontSize: 20, weight: .medium)
                .foregroundOverlay(myGradient(type: self.task.todoGradientScheme,
                                              colors: [self.task.todoGradientStartColor.color,
                                                       self.task.todoGradientEndColor.color]))
                .onTapGesture { self.task.isCompleted.toggle() }
            
            Text("\(self.task.todoName)").strikethrough(self.task.isCompleted, color: self.task.todoGradientStartColor.color)
                .font(.system(size: 20, weight: .regular, design: .monospaced))
                .fontWeight(.semibold)
                .foregroundOverlay(myGradient(type: self.task.todoGradientScheme,
                                              colors: [self.task.todoGradientStartColor.color,
                                                       self.task.todoGradientEndColor.color]))
        }
        .padding(.horizontal)
    }
}

struct TaskEditBarView: View {
    
    @ObservedObject var task: ToDoTask
    @State private var showingModal: Bool = false
    
    var body: some View {
        
        HStack {
            
            HStack(spacing: -10) {
                
                getSystemImage(name: "calendar",
                               color: .secondary,
                               fontSize: 12, weight: .light)
                    .opacity(0.70)
                    .padding(0)
                
                
                Text("Due on: \( customMiniDateFormatter.string(from: self.task.dueDateTime) )")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary).opacity(0.60)
            }
            .padding(.leading, -18)
            
            Spacer()
            
            HStack(spacing: -22) {
                
                getSystemImage(name: (self.task.isMyFavorite) ? "star.fill" : "star",
                               color: (self.task.isMyFavorite) ? Color.yellow.opacity(0.80) : Color.secondary.opacity(0.30),
                               fontSize: 14, scale: .small).padding(0)
                    .onTapGesture { self.task.isMyFavorite.toggle() }
                
                getSystemImage(name: "slider.horizontal.3",
                               color: Color.secondary.opacity(0.30),
                               fontSize: 14, scale: .medium).padding(0)
                    .onTapGesture { self.showingModal.toggle() }
                
            }
            .padding(.trailing, 4)
            
        }
        .offset(x: 10, y: 8)
        .onTapGesture { self.showingModal.toggle() }
        .sheet(isPresented: self.$showingModal) {
            
            // MARK: Call DetailView
            ListDetailView(task: self.task,
                           showModal: self.$showingModal)
        }
        
    }
}
