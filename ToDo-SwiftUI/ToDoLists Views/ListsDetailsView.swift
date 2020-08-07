//
//  ListsDetailsView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/19/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListsDetailsView: View {
    
    @State var list: ToDoList
    @Binding var showModal: Bool
    
    @State private var keyboard = KeyboardResponder()
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text(self.list.todoListIcon)
                    .font(.system(size: 24))
                    .shadow(color: Color.secondary.opacity(0.40),
                            radius: 2, x: 2, y: 4)
                
                Text(self.list.todoListName)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .offset(x: 0, y: 1)
                    .foregroundOverlay(
                        myGradient(type: self.list.todoGradientScheme,
                                   colors: [self.list.todoGradientStartColor.color,
                                            self.list.todoGradientEndColor.color]))
                
                Spacer()
                
                getSystemImage(name: "xmark.circle.fill",
                               weight: .medium, scale: .medium)
                    .padding(.trailing, -16)
                    .foregroundOverlay(
                        myGradient(type: self.list.todoGradientScheme,
                                   colors: [self.list.todoGradientStartColor.color,
                                            self.list.todoGradientEndColor.color]))
                    .onTapGesture { self.showModal.toggle() }
                
            }
            .padding(.horizontal)
            .padding(.top, 4)
            .padding(.bottom, -10)
            
            Form {
                
                HStack {
                    
                    Text("Progress:")
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", self.list.progress))%")
                }
                
                Section(header: headerItemGroup(imageName: "text.cursor", text: "Basic Info")) {
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            
                            Text("Name")
                            
                            Spacer()
                            
                            TextField("Label: ", text: self.$list.todoListName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(Color.primary.opacity(0.50))
                                .offset(x: 0 , y: 1)
                        }
                        .padding(.vertical)
                    }
                }
                
                Section(header: headerItemGroup(imageName: "slider.horizontal.below.rectangle", text: "Choose Icon")) {
                    
                    
                    HStack {
                        
                        Text("Emoji")
                        
                        Spacer()
                        
                        iconUserInput(keyboard: .twitter,
                                      placeholder: "Type an emoji...",
                                      textfield: self.$list.todoListIcon, lineLimit: 1,
                                      fontDesign: .default,
                                      fontSize: .body,
                                      scale: 0.78)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(Color.primary.opacity(0.50))
                        
                    }
                }
                
                Section(header: headerItemGroup(imageName: "dial.fill", text: "Change Look & Feel")) {
                    
                    VStack(alignment: .center) {
                        
                        myGradient(type: self.list.todoGradientScheme,
                                   colors: [self.list.todoGradientStartColor.color,
                                            self.list.todoGradientEndColor.color])
                            .cornerRadius(8)
                            .frame(height: 24)
                            .padding(.bottom, 4)
                        
                        Divider()
                        
                        
                        Picker(selection: self.$list.todoGradientScheme, label: Text("Color")) {
                            ForEach(GradientTypes.allCases, id: \.id) { gcolorName in
                                
                                Text(gcolorName.id).tag(gcolorName)
                                    .foregroundColor(.blue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 4)
                        
                        Divider()
                        
                        GradientColorRoll(text: "Start Color",
                                          selectedColor: self.$list.todoGradientStartColor)
                        
                        Divider()
                        
                        GradientColorRoll(text: "End Color",
                                          selectedColor: self.$list.todoGradientEndColor)
                        
                    }
                }
                
                
                Section(header: headerItemGroup(imageName: "text.badge.star", text: "More details")) {
                    
                    HStack {
                        
                        getSystemImage(name: self.list.isMyFavorite ?
                            "star.fill" : "star",
                                       color: .yellow)
                        
                        Text("Add to Favorites")
                    }
                    .onTapGesture { self.list.isMyFavorite.toggle() }
                    
                }
                
            }
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            
        }
    }
    
    func endEditing(_ force: Bool) {
        UIApplication.shared.endEditing()
    }
    
}

struct ListsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach(randomLists, id: \.id) { list in
            
            ListsDetailsView(list: list, showModal: .constant(true))
            
        }
    }
}
