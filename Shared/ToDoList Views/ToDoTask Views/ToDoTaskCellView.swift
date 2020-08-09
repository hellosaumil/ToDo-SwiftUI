//
//  ToDoTaskCellView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ToDoTaskCellView: View {
    
    @ObservedObject var task: ToDoTask
    @State private var moreInfoTapped: Bool = false
    
    var body: some View {
        
        ZStack {
            
            if moreInfoTapped {
                ZStack(alignment: .center) {
                    
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .foregroundColor(Color.secondary.opacity(0.10))
                        .frame(height: 20).offset(y: 8)
                    
                    // MARK: Call TaskEditBarView
                    TaskEditBarView(task: task)
                    
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
                ToDoCellRowItem(task: task)
            }
            .frame(height: 60)
            .onTapGesture {
                
                withAnimation(.interactiveSpring(response: 0.40, dampingFraction: 0.86, blendDuration: 0.25)) { moreInfoTapped.toggle() }
            }
            
            // MARK: Context Menu for ToDo Cell
            .contextMenu {
                
                Button(action: {} )
                    { Text("\(task.todoName)"); Image(systemName: "\(task.todoShape.id)") }
                
                Button(action: {} )
                { Text(" Due on \( customDateFormatter.string(from: task.dueDateTime)) ")
                    Image(systemName: "calendar") }
                
                Button(action: { withAnimation { task.isCompleted.toggle() } })
                { Text( task.isCompleted ? "Reset Task" : "Complete Task" )
                    Image(systemName: task.isCompleted ? "minus.circle.fill" : "checkmark.circle.fill") }
                
                Button(action: { withAnimation { task.isMyFavorite.toggle() } })
                { Text( task.isMyFavorite ? "Remove to Favorites" : "Add to Favorites" )
                    Image(systemName:  task.isMyFavorite ? "star.slash.fill" : "star.fill" ) }
                
            }
            
        }
        .padding(.vertical)
        .padding(.bottom, (moreInfoTapped) ? 20 : 0)
        
        .frame(maxWidth: 1200)
    }
}

struct ToDoTaskCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ToDoTaskCellView(task: someTask)
            .previewLayout(.sizeThatFits)
    }
}

struct ToDoCellRowItem: View {
    
    @ObservedObject var task: ToDoTask
    
    var body: some View {
        
        HStack {
            
            // MARK: Complete Task
            getSystemImage(name: "\(task.todoShape)" +
                            ((task.isCompleted) ? ".fill" : ""), color: .primary,
                           fontSize: 20, weight: .medium)
                .foregroundOverlay(myGradient(type: task.todoGradientScheme,
                                              colors: [task.todoGradientStartColor.color,
                                                       task.todoGradientEndColor.color]))
                .onTapGesture { task.isCompleted.toggle() }
            
            Text("\(task.todoName)").strikethrough(task.isCompleted, color: task.todoGradientStartColor.color)
                .font(.system(size: 20, weight: .regular, design: .monospaced))
                .fontWeight(.semibold)
                .foregroundOverlay(myGradient(type: task.todoGradientScheme,
                                              colors: [task.todoGradientStartColor.color,
                                                       task.todoGradientEndColor.color]))
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
                
                
                Text("Due on: \( customMiniDateFormatter.string(from: task.dueDateTime) )")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary).opacity(0.60)
            }
            .padding(.leading, -18)
            
            Spacer()
            
            HStack(spacing: -22) {
                
                getSystemImage(name: (task.isMyFavorite) ? "star.fill" : "star",
                               color: (task.isMyFavorite) ? Color.yellow.opacity(0.80) : Color.secondary.opacity(0.30),
                               fontSize: 14, scale: .small).padding(0)
                    .onTapGesture { task.isMyFavorite.toggle() }
                
                getSystemImage(name: "slider.horizontal.3",
                               color: Color.secondary.opacity(0.30),
                               fontSize: 14, scale: .medium).padding(0)
                    .onTapGesture { showingModal.toggle() }
                
            }
            .padding(.trailing, 4)
            
        }
        .offset(x: 10, y: 8)
        .onTapGesture { showingModal.toggle() }
        .sheet(isPresented: $showingModal) {
            
            // MARK: Call ToDoTaskInfoView
            ToDoTaskInfoView(task: task,
                             showModal: $showingModal)
        }
        
    }
}
