//
//  QuickListView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/11/20.
//

import SwiftUI
import WidgetKit

struct QuickListView: View {
    
    @ObservedObject var list: ToDoList
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        
        switch family {

            case .systemSmall, .systemMedium:

                VStack(alignment: .leading) {

                    HStack {

                        // MARK: Icon and Name
                        ListHeroLite(ofList: list)

                        // MARK: Task Summary
                        if family != .systemSmall {

                            Spacer()

                            TaskSummaryViewLite(ofList: list)
                        }

                    }

                    Spacer()

                    HStack(alignment: .bottom) {

                        // MARK: Progress Bar
                        VStack(alignment: .leading) {

                            Text("\(String(format: "%d", Int(list.progress)))% complete")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.bottom, -4)

                            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center))
                            {

                                HStack {

                                    Capsule(style: .continuous)
                                        .foregroundColor(Color.secondary.opacity(0.20))
                                        .frame(width: (family == .systemSmall) ? 100 : 240,
                                               height: (family == .systemSmall) ? 2 : 4)

                                    Spacer()
                                }

                                HStack {

                                    Capsule(style: .continuous)
                                        .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                                      colors: [list.todoGradientStartColor.color,
                                                                               list.todoGradientEndColor.color]))
                                        .frame(width: list.progress * 0.01 * ((family == .systemSmall) ? 100 : 240) ,
                                               height: (family == .systemSmall) ? 2 : 4)

                                    Spacer()

                                }
                            }
                        }

                        Spacer()

                        // MARK: Flags Status
                        HStack(spacing: (family == .systemSmall) ? 8 : 16 ) {

                            getSystemImage(name: (list.isMyFavorite) ? "star.fill" : "star",
                                           color: (list.isMyFavorite) ? Color.yellow.opacity(0.80) : Color.secondary.opacity(0.80),
                                           fontSize: (family == .systemSmall) ? 9 : 11,
                                           scale: (family == .systemSmall) ? .small : .medium)
                                .padding(-16)

                            getSystemImage(name: (list.isLocked) ? "lock.fill" : "lock.open",
                                           color: Color.secondary.opacity(0.80),
                                           fontSize: (family == .systemSmall) ? 10 : 12,
                                           scale: (family == .systemSmall) ? .small : .medium)
                                .padding(-16)

                        }
                        .offset(x: -4, y: (family == .systemSmall) ? 2 : 2)

                    }

                }
                .padding()

            default:
                Text("Family not supported: \(family.description)")
        }
    }
}

struct QuickListView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach([WidgetFamily.systemSmall, WidgetFamily.systemMedium], id: \.self) { family in
                
                QuickListView(list: ToDoList(icon: "📚🧐⚠️"))
                    .previewContext(WidgetPreviewContext(family: family))
            }
        }
    }
}

struct ListHeroLite: View {
    
    @Environment(\.widgetFamily) var family
    
    @ObservedObject var ofList: ToDoList
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(ofList.todoListIcon)
                .font( (family == .systemSmall) ? .title : .largeTitle )
                .shadow(color: Color.secondary.opacity(0.40),
                        radius: 2, x: 2, y: 4)
            
            
            Text(ofList.todoListName).strikethrough(ofList.progress == 100, color: ofList.todoGradientStartColor.color)
                .font(.system(size: (family == .systemSmall) ? 20 : 28, weight: .bold, design: .default))
                .truncationMode( (family == .systemSmall) ? .head : .middle)
                .lineLimit( (family == .systemSmall) ? 3 : 2)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundOverlay(myGradient(type: ofList.todoGradientScheme,
                                              colors: [ofList.todoGradientStartColor.color,
                                                       ofList.todoGradientEndColor.color]))
            
            Spacer(minLength: 0)
        }
    }
}

struct TaskSummaryViewLite: View {
    
    @ObservedObject var ofList: ToDoList
    
    var body: some View {
        
        ZStack {
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack(alignment: .top, spacing: 5) {
                    
                    Image(systemName: "bolt.fill").foregroundColor(.yellow)
                        .font(.body)
                        .imageScale(.large)
                        .padding(.top, 4)
                        .shadow(radius: 10)
                    
                    Text("Tasks\nSummary")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .opacity(0.80)
                    
                    
                }
                
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
                
                Spacer()
            }
            .padding(.top, 4)
            
            VStack {
                
                Spacer()
                
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
                
            }.offset(y: 10)
        }
    }
}
