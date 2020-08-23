//
//  ToDoListCellView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ToDoListCellView: View {
    
    @ObservedObject var list: ToDoList
    @State private var moreInfoTapped: Bool = false
    
    @State private var navLinkActive: Bool = false
    
    var body: some View {
        
        HStack {
            
            ZStack {
                
                if moreInfoTapped {
                    
                    ZStack(alignment: .center) {
                        
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                          colors: [list.todoGradientStartColor.color,
                                                                   list.todoGradientEndColor.color])).opacity(0.05)
                            .frame(height: 20).offset(y: 8)
                        
                        ProgressBarView(list: list)
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
                        ToDoListCellRowItem(list: list)
                        
                        Spacer()
                        
                        HStack (spacing: -12) {
                            
                            getSystemImage(name: list.isLocked ? "lock.fill" : "lock.open.fill", scale: .small)
                                .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                              colors: [list.todoGradientStartColor.color, list.todoGradientEndColor.color]))
                                .opacity( list.isLocked ? 0.75 : 0.50 )
                                .shadow(color: .secondary, radius: 4, x: 2, y: 2)
                                .onTapGesture(count: 2, perform: {
                                    if !list.isLocked { withAnimation{ list.isLocked = true } }
                                    else { authUser() }
                                })
                            
                            if !list.isLocked {
                                
                                // MARK: Call ListMasterView
                                ScrollView {
                                    
                                    NavigationLink(destination: ToDoTasksDetailView(toDoList: list), isActive: $navLinkActive) {
                                        
                                        getSystemImage(name: "chevron.right",
                                                       color: Color.secondary.opacity(0.35), fontSize: 12,
                                                       scale: .large).padding(.vertical, -10)
                                            
                                            
                                            .rotationEffect(Angle(degrees: (moreInfoTapped) ? 90 : 0))
                                    }
                                    .onOpenURL(perform: { (url) in
                                        self.navLinkActive = url == list.getURL()
                                    })
                                    
                                }.offset(y: 18)
                                
                            }
                            
                        }
                        
                    }
                    
                    // MARK: Context Menu for ToDoList Cell
                    .contextMenu {
                        
                        Button(action: {})
                            { Text("\(list.todoListIcon) \(list.todoListName)") }
                        
                        Button(action: {})
                        { Text("\(String(format: "%.1f", list.progress))% Progress")
                            Image(systemName: "arrow.triangle.2.circlepath") }
                        
                        if !list.todoTasks.isEmpty {
                            Button(action: {})
                            { Text("Total \(list.todoTasks.count) Tasks")
                                Image(systemName: "list.dash") }
                        }
                        
                        
                        // MARK: Complete/Reset All Tasks in the List
                        if !list.todoTasks.isEmpty && !list.isLocked {
                            
                            Button(action: {
                                
                                if list.isAllComplete() { list.completeTasks() }
                                else { list.incompleteTasks() }
                                withAnimation(.easeOut(duration: 0.5)) { list.updateProgress() }
                                
                            }) {
                                Text(list.isAllComplete() ? "Complete all tasks" : "Reset all tasks")
                                Image(systemName: list.isAllComplete() ? "checkmark" : "xmark")
                            }
                            
                        }
                        
                        if !list.isLocked {
                            
                            Button(action: {
                                // MARK: Call addNewList
                                _ = list.addNewTask()
                            })
                                { Text("Add New Task"); Image(systemName: "plus") }
                            
                            Button(action: { withAnimation { list.isMyFavorite.toggle() } })
                            { Text( list.isMyFavorite ? "Remove from Favorites" : "Add to Favorites" )
                                Image(systemName: list.isMyFavorite ? "star.slash.fill" : "star.fill" ) }
                            
                        }
                        
                        // MARK: Call authUser
                        Button(action: {
                            withAnimation { list.isLocked ? authUser() : list.isLocked.toggle() }
                        }) {
                            Text( !list.isLocked ? "Lock" : "Authenticate" )
                            Image(systemName: !list.isLocked ? "lock.fill" : "ellipsis.rectangle.fill" )
                        }
                    }
                }
                .frame(height: 60)
                .onAppear(perform: {list.updateProgress()})
                
            }
            .padding(.vertical)
            .padding(.bottom, (moreInfoTapped) ? 20 : 0)
            
            .onTapGesture {
                
                withAnimation(.interactiveSpring(response: 0.40, dampingFraction: 0.86, blendDuration: 0.25)) {
                    
                    list.resetProgress()
                    moreInfoTapped.toggle()
                    list.updateProgress()
                }
            }
            
        }
        .frame(maxWidth: 500)
    }
    
    // MARK: authUser: check if user unlocked using biometrics
    func authUser() {
        
        if list.isLocked {
            
            DispatchQueue.main.async {
                
                authenticate { (authStatus) in
                    
                    withAnimation { list.isLocked = authStatus }
                }
            }
            
        }
        
    }
}

struct ToDoListCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            ForEach([randomLists[0], ToDoList(icon:"🎑")], id: \.id) { list in
                
                //                NightAndDay {
                
                ToDoListCellView(list: list)
                    .previewLayout(.sizeThatFits)
                //                }
            }
        }
    }
}

struct ToDoListCellRowItem: View {
    
    @ObservedObject var list: ToDoList
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            Text(list.todoListIcon)
                .font(.system(size: 24))
                .shadow(color: Color.secondary.opacity(0.40),
                        radius: 2, x: 2, y: 4)
                .truncationMode(.head)
            
            Text(list.todoListName).strikethrough(list.progress == 100, color: list.todoGradientStartColor.color)
                .lineLimit(2).truncationMode(.head)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                              colors: [list.todoGradientStartColor.color,
                                                       list.todoGradientEndColor.color]))
                
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
            
            ProgressView(value: list.progress, total: 100.0)
                .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                              colors: [list.todoGradientStartColor.color,
                                                       list.todoGradientEndColor.color]))
            
            Spacer()
            
            HStack(spacing: -22) {
                
                getSystemImage(name: (list.isMyFavorite) ? "star.fill" : "star",
                               color: (list.isMyFavorite) ? Color.yellow.opacity(0.80) : Color.secondary.opacity(0.30),
                               fontSize: 14, scale: .small).padding(0)
                    .onTapGesture { if !list.isLocked { list.isMyFavorite.toggle() } }
                
                getSystemImage(name: "slider.horizontal.3",
                               color: Color.secondary.opacity(0.30),
                               fontSize: 14, scale: .medium).padding(0)
                    .onTapGesture { if !list.isLocked { showingModal.toggle() } }
                
            }
            .padding(.trailing, 4)
            
        }
        .offset(x: 10, y: 8)
        .onTapGesture { if !list.isLocked { showingModal.toggle() } }
        .sheet(isPresented: $showingModal) {
            
            // MARK: Call ToDoListInfoView
            ToDoListInfoView(list: list,
                             showModal: $showingModal)
            
        }
    }
}
