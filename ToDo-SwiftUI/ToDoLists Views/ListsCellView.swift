//
//  ListsCellView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/18/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListsCellView: View {
    
    @ObservedObject var list: ToDoList
    @State private var moreInfoTapped: Bool = false
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                ZStack {
                    
                    if moreInfoTapped {
                        ZStack(alignment: .center) {
                            
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .foregroundColor(Color.secondary.opacity(0.10))
                                .frame(height: 20).offset(y: 8)
                            
                            
                            ProgressBarView(list: self.list)
                                .animation(.easeInOut)
                            
                        }
                        .frame(height: 40)
                        .offset(y: (moreInfoTapped) ? 32 : 0)
                    }
                    
                    ZStack(alignment: .leading) {
                        
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .foregroundColor(.primary).colorInvert()
                            .shadow(color: Color.secondary.opacity(0.40),
                                    radius: 4, x: 0, y: 4)
                        
                        HStack {
                            
                            // MARK: Call ToDoListCellRowItem
                            ToDoListCellRowItem(list: self.list)
                            
                            Spacer()
                        }
                        .contextMenu {
                            // MARK: TODO Context Menu for ToDoList Cell
                            
                            Text("Name: \(self.list.todoListIcon) \(self.list.todoListName)").lineLimit(4)
                            
                            Text("Progress: \(String(format: "%.1f", self.list.progress))%")
                            
                            Button(action: {
                                self.list.completeTasks()
                                self.list.updateProgress()
                            }) {
                                Text("Complete All Tasks")
                                Image(systemName: "globe")
                            }
                            
                            Button(action: {
                                self.list.incompleteTasks()
                                self.list.updateProgress()
                            }) {
                                Text("Reset All Tasks")
                                Image(systemName: "globe")
                            }
                        }
                        
                        
                        
                    }
                    .frame(height: 60)
                    .onAppear(perform: {self.list.updateProgress()})
                    
                }
                .padding(.vertical)
                .padding(.bottom, (moreInfoTapped) ? 20 : 0)
                    
                .onTapGesture {
                    
                    withAnimation(.interactiveSpring(response: 0.40, dampingFraction: 0.86, blendDuration: 0.25)) {
                        
                        self.list.resetProgress()
                        self.moreInfoTapped.toggle()
                        self.list.updateProgress()
                        
                    }
                }
                
                // MARK: Call ListMasterView
                ScrollView {
                    
                    NavigationLink(destination: ListMasterView(toDoList: list)) {
                        
                        getSystemImage(name: "chevron.right",
                                       color: Color.secondary.opacity(0.35), fontSize: 12,
                                       scale: .large).padding(.vertical, -10)
                            
                            .rotationEffect(Angle(degrees: (moreInfoTapped) ? 90 : 0))
                        
                    }
                }
                .offset(y: UIScreen.main.bounds.height * 0.040 )
                .padding(.leading, UIScreen.main.bounds.width * 0.80 )
                
            }
            
            Divider()
                .padding(.horizontal, 16)
        }
        
    }
}

struct ListsCellView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach([sampleLists[0]], id: \.id) { list in
                
                NightAndDay {
                    
                    ListsCellView(list: list)
                        .previewLayout(.sizeThatFits)
                }
            }
        }
    }
}

struct ToDoListCellRowItem: View {
    
    @ObservedObject var list: ToDoList
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            Text(self.list.todoListIcon)
                .font(.system(size: 24))
                .shadow(color: Color.secondary.opacity(0.40),
                        radius: 2, x: 2, y: 4)
            
            Text(self.list.todoListName).strikethrough(self.list.progress == 100, color: self.list.todoGradientStartColor.color)
                .lineLimit(1)
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundOverlay(myGradient(type: self.list.todoGradientScheme,
                                              colors: [self.list.todoGradientStartColor.color,
                                                       self.list.todoGradientEndColor.color]))
                
                .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

struct ProgressBarView: View {
    
    @ObservedObject var list: ToDoList
    @State private var showingModal: Bool = false
    
    var body: some View {
        
        HStack {
            
            ZStack(alignment: .center) {
                
                ProgressBarItem(percentComplete: .constant(100))
                    .foregroundColor(Color.secondary.opacity(0.20))
                
                ProgressBarItem(percentComplete: self.$list.progress)
                    .foregroundOverlay(myGradient(type: self.list.todoGradientScheme,
                                                  colors: [self.list.todoGradientStartColor.color,
                                                           self.list.todoGradientEndColor.color]))
                
            }
            
            Spacer()
            
            
            HStack(spacing: -22) {
                
                getSystemImage(name: (self.list.isMyFavorite) ? "star.fill" : "star",
                               color: (self.list.isMyFavorite) ? Color.yellow.opacity(0.80) : Color.secondary.opacity(0.30),
                               fontSize: 14, scale: .small).padding(0)
                    .onTapGesture { self.list.isMyFavorite.toggle() }
                
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
            
            // MARK: Call ListsDetailView
            ListsDetailsView(list: self.list,
                             showModal: self.$showingModal)
            
        }
    }
}

struct ProgressBarItem: View {
    
    @Binding var percentComplete:CGFloat
    @State var totalWidth: CGFloat = 0.70
    @State var barHeight: CGFloat = 4
    
    var body: some View {
        
        HStack {
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * 0.90 * totalWidth * (percentComplete/100),
                       height: barHeight)
            
            Spacer()
        }
    }
}
