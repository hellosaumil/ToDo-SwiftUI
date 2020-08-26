//
//  ToDoListInfoView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

struct ToDoListInfoView: View {
    
    @ObservedObject var list: ToDoList
    @Binding var showModal: Bool
    
    @State var selectedIcon: iconPresets = iconPresets.allCases.randomElement()!
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text(list.todoListIcon)
                    .font(.system(size: 24))
                    .shadow(color: Color.secondary.opacity(0.40),
                            radius: 2, x: 2, y: 4)
                
                Text(list.todoListName)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .offset(x: 0, y: 1)
                    .foregroundOverlay(
                        myGradient(type: list.todoGradientScheme,
                                   colors: [list.todoGradientStartColor.color,
                                            list.todoGradientEndColor.color]))
                
                Spacer()
                
                getSystemImage(name: "xmark.circle.fill",
                               weight: .medium, scale: .medium)
                    .padding(.trailing, -16)
                    .foregroundOverlay(
                        myGradient(type: list.todoGradientScheme,
                                   colors: [list.todoGradientStartColor.color,
                                            list.todoGradientEndColor.color]))
                    .onTapGesture { showModal.toggle() }
                
            }
            .padding(.horizontal)
            .padding(.top, 4)
            .padding(.bottom, -10)
            
            Form {
                
                VStack(spacing: 6) {
                    
                    HStack {
                        
                        Text("Progress:")
                        
                        Spacer()
                        
                        Text("\(String(format: "%.1f", list.progress))%")
                        
                    }
                    
                    ProgressView(value: list.progress, total: 100.0)
                        .foregroundOverlay(myGradient(type: list.todoGradientScheme,
                                                      colors: [list.todoGradientStartColor.color,
                                                               list.todoGradientEndColor.color]))
                }
                
                Section(header: headerItemGroup(imageName: "text.cursor", text: "Basic Info")) {
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            
                            Text("Name")
                            
                            Spacer()
                            
                            TextField("Label: ", text: $list.todoListName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(Color.primary.opacity(0.50))
                                .offset(x: 0 , y: 1)
                        }
                        .padding(.vertical)
                    }
                }
                
                Section(header: headerItemGroup(imageName: "slider.horizontal.below.rectangle", text: "Choose Icon")) {
                    
                    
                    HStack {
                        
                        Text("Emoji Icon")
                        
                        Spacer()
                        
                        iconUserInput(keyboard: .twitter,
                                      placeholder: "Type an emoji...",
                                      textfield: $list.todoListIcon, lineLimit: 1,
                                      fontDesign: .default,
                                      fontSize: .body,
                                      scale: 0.78)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(Color.primary.opacity(0.50))
                        
                    }
                }
                
                Section(header: headerItemGroup(imageName: "dial.fill", text: "Change Look & Feel")) {
                    
                    VStack(alignment: .center) {
                        
                        myGradient(type: list.todoGradientScheme,
                                   colors: [list.todoGradientStartColor.color,
                                            list.todoGradientEndColor.color])
                            .cornerRadius(8)
                            .frame(height: 24)
                            .padding(.bottom, 4)
                        
                        Divider()
                        
                        
                        Picker(selection: $list.todoGradientScheme, label: Text("Color")) {
                            ForEach(GradientTypes.allCases, id: \.id) { gcolorName in
                                
                                Text(gcolorName.id).tag(gcolorName)
                                    .foregroundColor(.blue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 4)
                        
                        Divider()
                        
                        GradientColorRoll(text: "Start Color",
                                          selectedColor: $list.todoGradientStartColor)
                        
                        Divider()
                        
                        GradientColorRoll(text: "End Color",
                                          selectedColor: $list.todoGradientEndColor)
                        
                    }
                }
                
                
                Section(header: headerItemGroup(imageName: "text.badge.star", text: "More details")) {
                    
                    HStack {
                        
                        getSystemImage(name: list.isMyFavorite ?
                                        "star.fill" : "star",
                                       color: .yellow)
                        
                        Text("Add to Favorites")
                    }
                    .padding(-14)
                    .onTapGesture { list.isMyFavorite.toggle() }
                    
                }
                
            }
//            .padding(.bottom, keyboard.currentHeight)
//            .edgesIgnoringSafeArea(.bottom)
            
        }
        .onDisappear {
            // MARK: Update Stored Lists onDelete
            DispatchQueue.main.async { userLists.saveLists() }
        }
    }
}

struct ToDoListInfoView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ForEach(randomLists, id: \.id) { list in
            
            ToDoListInfoView(list: list, showModal: .constant(true))
            
        }
    }
}
