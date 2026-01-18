//
//  ToDoListCellView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ToDoListCellView: View {
    
    @ObservedObject var list: ToDoList
    @Binding var navigationPath: NavigationPath
    @State private var moreInfoTapped: Bool = true
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Main card content
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(.primary).colorInvert()
                    .shadow(color: Color.secondary.opacity(0.40),
                            radius: 4, x: 0, y: 4)
                
                HStack {
                    
                    // Icon and name
                    ToDoListCellRowItem(list: list)
                    
                    Spacer()
                    
                    // Lock icon
                    getSystemImage(name: list.isLocked ? "lock.fill" : "lock.open.fill", scale: .small)
                        .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                      colors: [list.todoGradientStartColor.color, list.todoGradientEndColor.color]))
                        .opacity( list.isLocked ? 0.75 : 0.50 )
                        .onTapGesture(count: 2, perform: {
                            if !list.isLocked {
                                withAnimation{ list.isLocked = true
                                    DispatchQueue.main.async { userLists.saveLists() }
                                }
                            } else { authUser() }
                        })
                    
                    // Chevron icon - tappable for navigation
                    if !list.isLocked {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.secondary.opacity(0.4))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                navigationPath.append(list)
                            }
                    }
                    
                }
                .padding(.trailing, 12)
            }
            .frame(height: 60)
            
            // Progress bar section (shown when moreInfoTapped)
            if moreInfoTapped {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                      colors: [list.todoGradientStartColor.color,
                                                               list.todoGradientEndColor.color])).opacity(0.05)
                        .frame(height: 24)
                    
                    ProgressBarView(list: list)
                }
                .padding(.top, -10)
            }
            
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.40, dampingFraction: 0.86, blendDuration: 0.25)) {
                list.resetProgress()
                moreInfoTapped.toggle()
                list.updateProgress()
            }
        }
        .onAppear(perform: {list.updateProgress()})
        
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
                    
                    DispatchQueue.main.async { userLists.saveLists() }
                    
                }) {
                    Text(list.isAllComplete() ? "Complete all tasks" : "Reset all tasks")
                    Image(systemName: list.isAllComplete() ? "checkmark" : "xmark")
                }
                
            }
            
            if !list.isLocked {
                
                Button(action: {
                    _ = list.addNewTask()
                })
                { Text("Add New Task"); Image(systemName: "plus") }
                
                Button(action: { withAnimation {
                        list.isMyFavorite.toggle() }
                    DispatchQueue.main.async { userLists.saveLists() }
                })
                { Text( list.isMyFavorite ? "Remove from Favorites" : "Add to Favorites" )
                    Image(systemName: list.isMyFavorite ? "star.slash.fill" : "star.fill" ) }
                
            }
            
            // MARK: Call authUser
            Button(action: {
                withAnimation { list.isLocked ? authUser() : list.isLocked.toggle() }
                DispatchQueue.main.async { userLists.saveLists() }
            }) {
                Text( !list.isLocked ? "Lock" : "Authenticate" )
                Image(systemName: !list.isLocked ? "lock.fill" : "ellipsis.rectangle.fill" )
            }
        }
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
                
                ToDoListCellView(list: list, navigationPath: .constant(NavigationPath()))
                    .previewLayout(.sizeThatFits)
                //                }
            }
        }
    }
}

struct ToDoListCellRowItem: View {
    
    @ObservedObject var list: ToDoList
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Text(list.todoListIcon)
                .font(.system(size: 24))
                .shadow(color: Color.secondary.opacity(0.40),
                        radius: 2, x: 2, y: 4)
            
            Text(list.todoListName)
                .strikethrough(list.progress == 100, color: list.todoGradientStartColor.color)
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                              colors: [list.todoGradientStartColor.color,
                                                       list.todoGradientEndColor.color]))
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
                    .onTapGesture { if !list.isLocked {
                        list.isMyFavorite.toggle()
                        
                        // MARK: Update Stored Lists
                        DispatchQueue.main.async { userLists.saveLists() }
                    } }
                
                getSystemImage(name: "slider.horizontal.3",
                               color: Color.secondary.opacity(0.30),
                               fontSize: 14, scale: .medium).padding(0)
                    .onTapGesture { if !list.isLocked {
                        showingModal.toggle()
                        
                        // MARK: Update Stored Lists
                        DispatchQueue.main.async { userLists.saveLists() }
                    } }
                
            }
            .padding(.trailing, 4)
            
        }
        .padding(.horizontal, 10)
        .onTapGesture { if !list.isLocked { showingModal.toggle() } }
        .sheet(isPresented: $showingModal) {
            
            // MARK: Call ToDoListInfoView
            ToDoListInfoView(list: list,
                             showModal: $showingModal)
            
        }
    }
}
