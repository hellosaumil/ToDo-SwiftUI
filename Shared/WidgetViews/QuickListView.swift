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
                        VStack(alignment: .leading) {
                            
                            Text(list.todoListIcon)
                                .font( (family == .systemSmall) ? .title : .largeTitle )
                                .shadow(color: Color.secondary.opacity(0.40),
                                        radius: 2, x: 2, y: 4)
                            
                            
                            Text(list.todoListName).strikethrough(list.progress == 100, color: list.todoGradientStartColor.color)
                                .font(.system(size: (family == .systemSmall) ? 20 : 28, weight: .bold, design: .default))
                                .truncationMode( (family == .systemSmall) ? .head : .middle)
                                .lineLimit( (family == .systemSmall) ? 3 : 2)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                              colors: [list.todoGradientStartColor.color,
                                                                       list.todoGradientEndColor.color]))
                        }
                        
                        
                        // MARK: Task Summary
                        if family != .systemSmall {
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                
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
                                
                                if list.todoTasks.count != 0 {
                                    
                                    HStack(spacing: 10) {
                                        
                                        Image(systemName: "0.circle.fill")
                                            .imageScale(.medium)
                                        
                                        Text("No Tasks")
                                            .fontWeight(.medium)
                                        
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .opacity(0.50)
                                    
                                } else {
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text("Total \(list.todoTasks.count) Tasks")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.pink)
                                            .opacity(0.80)
                                        
                                        
                                        Text("✓ \(list.todoTasks.filter({ $0.isCompleted }).count)" +
                                                "\t\tx \(list.todoTasks.filter({ !$0.isCompleted }).count)")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                                          colors: [list.todoGradientStartColor.color,
                                                                                   list.todoGradientEndColor.color]))
                                            .opacity(0.60)
                                        
                                    }
                                    
                                }
                                
                                Spacer()
                            }
                            .padding(.top, 4)
                        }
                        
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        
                        // MARK: Progress Bar
                        VStack(alignment: .leading) {
                            
                            Text("\(String(format: (list.progress > 0) ? "%.1f" : "%d", list.progress))% complete")
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
                        .offset(y: (family == .systemSmall) ? 2 : 2)
                        
                    }
                    
                }
                .padding()
                
            default:
                Text("Family not supported: \(family.description)")
        }
    }
}

//struct QuickListView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuickListView(list: ToDoList(icon: "📚🧐⚠️"))
//            .previewLayout(.sizeThatFits)
//    }
//}
