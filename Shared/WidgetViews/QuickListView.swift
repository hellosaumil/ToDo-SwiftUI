//
//  QuickListView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/11/20.
//

import SwiftUI
import WidgetKit

struct QuickListView: View {
    
    var list: ToDoList
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        
        switch family {
            
            case .systemSmall, .systemMedium:
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        
                        Text(list.todoListIcon)
                            .font(.title)
                            .shadow(color: Color.secondary.opacity(0.40),
                                    radius: 2, x: 2, y: 4)
                        
                        Text(list.todoListName).strikethrough(list.progress == 100, color: list.todoGradientStartColor.color)
                            .font(.system(size: 22, weight: .bold, design: .default))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                          colors: [list.todoGradientStartColor.color,
                                                                   list.todoGradientEndColor.color]))
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        
                        VStack(alignment: .leading) {
                            
                            Text("\(String(format: (list.progress > 0) ? "%.1f" : "%d", list.progress))% complete")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: true, vertical: false)
                            
                            ProgressView(value: list.progress, total: 100.0)
                                .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                              colors: [list.todoGradientStartColor.color,
                                                                       list.todoGradientEndColor.color]))
                                .frame(width: 90, height: 2, alignment: .center)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                            getSystemImage(name: (list.isMyFavorite) ? "star.fill" : "star",
                                           color: (list.isMyFavorite) ? Color.yellow.opacity(0.80) : Color.secondary.opacity(0.80),
                                           fontSize: 8, scale: .small).padding(-16)
                            
                            getSystemImage(name: (list.isLocked) ? "lock.fill" : "lock.open",
                                           color: Color.secondary.opacity(0.80),
                                           fontSize: 8, scale: .small).padding(-16)
                        }
                        .offset(y: -3)
                        
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
        QuickListView(list: ToDoList(icon: "🎑"))
            .previewLayout(.sizeThatFits)
    }
}
