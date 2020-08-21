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
                .padding(.bottom, (family == .systemLarge) ? 4 : 8)
            
            LazyVGrid(columns: columns) {
                
                ForEach(0 ..< ((family == .systemLarge) ? 10 : 4), id: \.self) { idx in
                    
                    TaskCellLite(task: (idx < list.todoTasks.count) ?
                                    list.todoTasks[idx] :
                                    ToDoTask(name: "placeholder \nredacted..."))
                        .redacted(reason: (idx < list.todoTasks.count) ? .init() : .placeholder)
                        .padding(.horizontal, 2)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, (family == .systemLarge) ? 2 : 0)
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
        
            HStack {
            
            Text(ofList.todoListIcon)
                .font(.title )
                .shadow(color: Color.secondary.opacity(0.40),
                        radius: 2, x: 2, y: 4)
            
            Text(ofList.todoListName).strikethrough(ofList.progress == 100, color: ofList.todoGradientStartColor.color)
                .font(.system(size: (family == .systemLarge) ? 24 : 22, weight: .bold, design: .default))
                .lineLimit(2).truncationMode(.middle)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundOverlay(myGradient(type: ofList.todoGradientScheme,
                                              colors: [ofList.todoGradientStartColor.color,
                                                       ofList.todoGradientEndColor.color]))
            
            Spacer(minLength: 0)
        }

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
                .font(.system(size: (family == .systemLarge) ? 16 : 14, weight: .semibold, design: .monospaced)).lineSpacing(4)
                .lineLimit(2).truncationMode(.middle)
                .frame(width: 115, height: (family == .systemLarge) ? 45 : 40)
                .foregroundOverlay(myGradient(type: task.todoGradientScheme,
                                              colors: [task.todoGradientStartColor.color,
                                                       task.todoGradientEndColor.color]))
        }
    }
}

struct QuickTasksView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            ForEach([WidgetFamily.systemLarge, WidgetFamily.systemMedium], id: \.self) { family in
                
                QuickTasksView(list: randomLists[0])
                    .previewContext(WidgetPreviewContext(family: family))
                
                QuickTasksView(list: ToDoList(icon: "🌖"))
                    .previewContext(WidgetPreviewContext(family: family))
                
            }
        }
    }
}
