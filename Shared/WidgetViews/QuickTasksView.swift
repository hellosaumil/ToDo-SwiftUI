//
//  QuickTasksView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/14/20.
//

import SwiftUI
import WidgetKit

struct QuickTasksView: View {
    
    @Environment(\.widgetFamily) var family
    
    @ObservedObject var list: ToDoList
    
    var columns: [GridItem] =
        Array(repeating: .init( .flexible(maximum: 165) ), count: 2)
    
    var body: some View {
        
        VStack {
            
            ListHeroTasksLite(ofList: list)
                .padding(.vertical, 4)
            
            Divider()
                .padding(.bottom, 4)
            
            LazyVGrid(columns: columns) {
                
                ForEach(0 ..< 10, id: \.self) { idx in
                    
                    TaskCellLite(task: (idx < list.todoTasks.count) ?
                                    list.todoTasks[idx] :
                                    ToDoTask(name: "placeholder \nredacted..."))
                        .redacted(reason: (idx < list.todoTasks.count) ? .init() : .placeholder)
                        .padding(.horizontal, 2)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
            }
            
        }
        .padding()
    }
}

struct ListHeroTasksLite: View {
    
    @Environment(\.widgetFamily) var family
    
    @ObservedObject var ofList: ToDoList
    
    var body: some View {
        
        HStack {
            
            Text(ofList.todoListIcon)
                .font(.title )
                .shadow(color: Color.secondary.opacity(0.40),
                        radius: 2, x: 2, y: 4)
            
            Text(ofList.todoListName).strikethrough(ofList.progress == 100, color: ofList.todoGradientStartColor.color)
                .font(.system(size: 22, weight: .bold, design: .default))
                .lineLimit(2).truncationMode(.middle)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundOverlay(myGradient(type: ofList.todoGradientScheme,
                                              colors: [ofList.todoGradientStartColor.color,
                                                       ofList.todoGradientEndColor.color]))
            
            Spacer()
            
            VStack(alignment: .leading) {
                
                if ofList.todoTasks.count == 0 {
                    
                    Text("No Tasks")
                        .fontWeight(.bold)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .opacity(0.60)
                        .padding(.leading, 20)
                    
                } else {
                    
                    VStack(spacing: 4) {
                        
                        Text("Total \(ofList.todoTasks.count) Tasks")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                        
                        HStack(alignment: .center, spacing: 36) {
                            
                            ForEach(0..<2, id: \.self) { bad_countx in
                                
                                HStack(alignment: .center, spacing: 4) {
                                    
                                    Image(systemName: (bad_countx == 0) ? "checkmark" : "hourglass")
                                    
                                    Text( (bad_countx == 0) ? "\(ofList.tasksCompleted)" : "\(ofList.tasksPending)" )
                                        .fontWeight(.bold)
                                    
                                }.font(.caption2)
                                .foregroundColor( (bad_countx == 0) ? ofList.todoGradientEndColor.color : ofList.todoGradientStartColor.color)
                                .brightness(-0.20)
                                
                            }
                        }
                        
                    }
                    .opacity(0.85)
                }
                
                Spacer(minLength: 6)
                
                // MARK: Go-to list widgetURL Caller
                Link(destination: ofList.getURL()) {
                    
                    HStack(alignment: .bottom, spacing: 5) {
                        
                        Text("Go to list")
                            .fontWeight(.bold)
                            .foregroundOverlay(myGradient(type: ofList.todoGradientScheme,
                                                          colors: [ofList.todoGradientStartColor.color,
                                                                   ofList.todoGradientEndColor.color]))
                        
                        getSystemImage(name: "arrow.up.forward.app.fill", color: .secondary,
                                       fontSize: 15, weight: .medium, design: .rounded,
                                       scale: .medium).padding(-16)
                            .foregroundOverlay(myGradient(type: ofList.todoGradientScheme,
                                                          colors: [ofList.todoGradientStartColor.color,
                                                                   ofList.todoGradientEndColor.color]))
                    }
                    .font(.caption2)
                    .padding(.leading, 5)
                    
                }
            }
            .padding(.top, 4)
        }
    }
}

struct TaskCellLite: View {
    
    @Environment(\.widgetFamily) var family
    
    @ObservedObject var task: ToDoTask
    
    var columnsLite: [GridItem] =
        [GridItem(.fixed(12)),
         GridItem(.flexible())]
    
    
    var body: some View {
        
        LazyVGrid(columns: columnsLite) {
            
            // MARK: Complete Task
            getSystemImage(name: "\(task.todoShape.name)" +
                            ((task.isCompleted) ? ".fill" : ""), color: .primary,
                           fontSize: 12, weight: .bold)
                .padding(-16).padding(.bottom, 25)
                .foregroundOverlay(myGradient(type: task.todoGradientScheme,
                                              colors: [task.todoGradientStartColor.color,
                                                       task.todoGradientEndColor.color]))
            
            Text("\(task.todoName)").strikethrough(task.isCompleted, color: task.todoGradientStartColor.color)
                .font(.system(size: 16, weight: .semibold, design: .monospaced)).lineSpacing(4)
                .lineLimit(2).truncationMode(.middle)
                .frame(width: 115, height: 45)
                .foregroundOverlay(myGradient(type: task.todoGradientScheme,
                                              colors: [task.todoGradientStartColor.color,
                                                       task.todoGradientEndColor.color]))
        }
    }
}

struct QuickTasksView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            ForEach([WidgetFamily.systemLarge], id: \.self) { family in
                
                QuickTasksView(list: randomLists[0])
                    .previewContext(WidgetPreviewContext(family: family))
                
                QuickTasksView(list: ToDoList(icon: "🌖"))
                    .previewContext(WidgetPreviewContext(family: family))
                
            }
        }
    }
}
