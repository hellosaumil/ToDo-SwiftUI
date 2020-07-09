//
//  ListDetailView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListDetailView: View {
    
    @State var detailTitle: String = "In Detail"
    
    @State var eventDate = Date()
    @State var eventTime = Date()
    
    @State var selectedColor:BaseColors = .orange
    @State var selectedShape:BaseShapes = .hexagon
    
    @State var isMyFavorite:Bool = false
    
    
    var body: some View {
        
        Form {
            
            Section(header: Text("Customize")) {
                
                VStack(alignment: .center) {
                    
                    HStack {
                        
                        Text("Name")
                        
                        commonUserInput(keyboard: .default,
                                        placeholder: "Type a new task name...",
                                        textfield: $detailTitle, lineLimit: 2,
                                        fontDesign: .monospaced,
                                        fontSize: .body,
                                        scale: 0.88)
                            .foregroundColor(Color.primary.opacity(0.75))
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    Picker(selection: $selectedColor, label: Text("Color")) {
                        ForEach(BaseColors.allCases, id: \.id) { colorName in
                            
                            Text(colorName.id).tag(colorName)
                                .foregroundColor(.blue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 4)
                    
                    
                    Picker(selection: $selectedShape, label: EmptyView()) {
                        
                        ForEach(BaseShapes.allCases, id: \.id) { shapeName in
                            
                            shapeName.filled.tag(shapeName)
                                .rotationEffect(Angle(degrees: -90.0))
                                .foregroundColor( self.selectedColor.color )
                                .imageScale(.medium)
                            
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 32, alignment: .center)
                    .rotationEffect(Angle(degrees: 90.0))
                    .scaledToFit()
                    .clipped()
                    .padding(.vertical, 4)
                }
            }
            
            
            Section(header: Text("Reminde me on the")) {
                
                DatePicker(selection: $eventDate,
                           in: Date()...,
                           displayedComponents: .date,
                           label: {Text("Date")} )
                
                
                DatePicker(selection: $eventTime,
                           in: Date()...,
                           displayedComponents: .hourAndMinute,
                           label: {Text("Time")} )
                
            }
            
            Section(header: Text("More details")) {
                
                TextFieldView(title: "Notes",
                              text: .constant(""),
                              placeholder: "Note here so you don't forget...",
                              backgroundColor: Color.primary.opacity(0.05))
                    .frame(height: 160)
                    .padding(.vertical)
                
                
                HStack {
                    
                    getSystemImage( isMyFavorite ? "star.fill" : "star",
                                    font: .body,
                                    color: .yellow)
                    
                    Text("Add to Favorites")
                }
                .onTapGesture { self.isMyFavorite.toggle() }
            }
            
        }
        .onTapGesture {
            self.endEditing(true)
        }
            
        .navigationBarTitle(Text("\(detailTitle)"))
    }
    
    func endEditing(_ force: Bool) {
        UIApplication.shared.endEditing()
    }
    
}

let tasks: [ToDoTask] = [
    ToDoTask(),
    ToDoTask(name: "Practice iOS Dev",
             dueDate: Date()+2, dueTime: Date()+2,
             color: .purple, shape: .triangle,
             isFav: true)
]

struct ListDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            NightAndDay { ListDetailView() }
            
            ForEach(tasks, id: \.self) { task in
                
                NightAndDay {
                    
                    ListDetailView(detailTitle: task.todoName,
                                   eventDate: task.dueTime,
                                   eventTime: task.dueTime,
                                   selectedColor: task.todoColor,
                                   selectedShape: task.todoShape,
                                   isMyFavorite: task.isMyFavorite)
                    
                }
            }
        }
    }
}
