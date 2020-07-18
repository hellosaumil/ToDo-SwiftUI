//
//  ListsCellView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/18/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListsCellView: View {
    
    @Binding var list: ToDoList
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(.primary).colorInvert()
                    .shadow(color: Color.secondary.opacity(0.40),
                            radius: 4, x: 2, y: 4)
                
                // MARK: Call ListMasterView
                NavigationLink(destination: ListMasterView(toDoList: self.$list)) {
                    
                    HStack {
                        
                        HStack(spacing: 0) {
                            
                            Text(self.list.todoListIcon)
                                .font(.system(size: 26))
                                .shadow(color: Color.secondary.opacity(0.40),
                                        radius: 2, x: 2, y: 4)
                            
                            Text(self.list.todoListName)
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                                .foregroundOverlay(
                                    myGradient(type: .linear,
                                               colors: [.pink, .purple]))
                                .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        getSystemImage(name: "chevron.right", color: Color.secondary.opacity(0.35),
                                       font: .callout, scale: .medium)
                    }
                }
            }
            .padding(.horizontal, 10)
            .frame(height: 60)
            
            Divider()
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
        }
    }
}

struct ListsCellView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach(sampleLists, id: \.todoListID) { list in
                
                //                NightAndDay {
                ListsCellView(list: .constant(list))
                    .previewLayout(.sizeThatFits)
                //                }
                
            }
            
        }
    }
}
