//
//  ListDetailView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListDetailView: View {
    
    @Binding var task: ToDoTask
    @Binding var showModal: Bool
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text(self.task.todoName)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundOverlay(
                        myGradient(type: self.task.todoGradientScheme,
                                   colors: [self.task.todoGradientStartColor.color,
                                            self.task.todoGradientEndColor.color]))
                
                Spacer()
                
                getSystemImage(name: "xmark.circle.fill",
                               font: .headline, scale: .medium)
                    .foregroundOverlay(
                        myGradient(type: self.task.todoGradientScheme,
                                   colors: [self.task.todoGradientStartColor.color,
                                            self.task.todoGradientEndColor.color]))
                    .onTapGesture { self.showModal.toggle() }
                
            }
            .padding(.horizontal)
            .padding(.top, 4)
            .padding(.bottom, -10)
            
            Form {
                
                Section(header: headerItemGroup(imageName: "text.cursor", text: "Basic Info")) {
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            
                            Text("Name")
                            
                            Spacer()
                            
                            commonUserInput(keyboard: .numbersAndPunctuation,
                                            placeholder: "Type a new task name...",
                                            textfield: self.$task.todoName, lineLimit: 2,
                                            fontDesign: .rounded,
                                            fontSize: .body,
                                            scale: 0.88)
                                .offset(x: 0, y: 1)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(Color.primary.opacity(0.50))
                        }
                        .padding(.vertical)
                    }
                }
                
                Section(header: headerItemGroup(imageName: "square.on.circle.fill", text: "Choose Shape")) {
                    
                    VStack(alignment: .center) {
                        
                        
                        Picker(selection: self.$task.todoShape, label: EmptyView()) {
                            
                            ForEach(BaseShapes.allCases, id: \.id) { shapeName in
                                
                                getSystemImage(name: shapeName.rawValue+".fill", font: .body,
                                               scale: .large)
                                    .tag(shapeName)
                                    .rotationEffect(Angle(degrees: -90.0))
                                    
                                    .foregroundOverlay(
                                        myGradient(type: self.task.todoGradientScheme,
                                                   colors: [self.task.todoGradientStartColor.color,
                                                            self.task.todoGradientEndColor.color]))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 32, alignment: .center)
                        .rotationEffect(Angle(degrees: 90.0))
                        .scaledToFit()
                        .clipped()
                        .padding(.vertical, 4)
                        
                        Divider()
                        
                        myGradient(type: self.task.todoGradientScheme,
                                   colors: [self.task.todoGradientStartColor.color,
                                            self.task.todoGradientEndColor.color])
                            .cornerRadius(8)
                            .frame(height: 24)
                            .padding(.bottom, 4)
                        
                    }
                }
                
                Section(header: headerItemGroup(imageName: "dial.fill", text: "Change Look & Feel")) {
                    
                    VStack(alignment: .center) {
                        
                        Picker(selection: self.$task.todoGradientScheme, label: Text("Color")) {
                            ForEach(GradientTypes.allCases, id: \.id) { gcolorName in
                                
                                Text(gcolorName.id).tag(gcolorName)
                                    .foregroundColor(.blue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 4)
                        
                        Divider()
                        
                        GradientColorRoll(text: "Start Color",
                                          selectedColor: self.$task.todoGradientStartColor)
                        
                        Divider()
                        
                        GradientColorRoll(text: "End Color",
                                          selectedColor: self.$task.todoGradientEndColor)
                        
                    }
                }
                
                Section(header: headerItemGroup(imageName: "calendar", text: "Reminde me on the")) {
                    
                    DatePicker(selection: self.$task.dueDateTime,
                               in: Date()...,
                               displayedComponents: [.hourAndMinute, .date] ,
                               label: {Text("Date & Time")} )
                    
                }
                
                Section(header: headerItemGroup(imageName: "text.badge.star", text: "More details")) {
                    
                    VStack (alignment: .leading, spacing: 10) {
                        
                        Text("Notes").bold()
                        
                        commonUserInput(keyboard: .default,
                                        placeholder: "Note so you don't forget...",
                                        textfield: self.$task.notes, lineLimit: 10,
                                        fontDesign: .rounded,
                                        fontSize: .body,
                                        scale: 0.88)
                            
                            .padding()
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(Color.primary.opacity(0.75))
                            
                            .background(Color.primary.opacity(0.05))
                            .cornerRadius(10)
                        
                    }
                    .padding(.vertical)
                    
                    HStack {
                        
                        getSystemImage(name: self.task.isMyFavorite ?
                            "star.fill" : "star",
                                       color: .yellow, font: .body)
                        
                        Text("Add to Favorites")
                    }
                    .onTapGesture { self.task.isMyFavorite.toggle() }
                    
                }
            }
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.primary.colorInvert())
        
    }
    
    func endEditing(_ force: Bool) {
        UIApplication.shared.endEditing()
    }
    
}

struct ListDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        
        ForEach(sampleTasksLite, id: \.todoID) { task in
            
            Group {
                
                NightAndDay {
                    ListDetailView(task: .constant(task),
                                   showModal: .constant(true))
                }
            }
        }
    }
}


final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    
    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}

struct GradientColorRoll: View {
    
    @State var text: String = "Choose Color"
    @Binding var selectedColor: BaseColors
    
    var body: some View {
        
        HStack {
            
            Text(text).lineLimit(2)
                .scaledToFit()
            
            Spacer()
            
            Picker(selection: self.$selectedColor, label: EmptyView()) {
                
                ForEach(BaseColors.allCases, id: \.id) { colorName in
                    
                    BaseShapes.square.filled.tag(colorName)
                        .rotationEffect(Angle(degrees: -90.0))
                        .foregroundColor( colorName.color )
                        .imageScale(.medium)
                        .padding(.trailing, 8)
                    
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: UIScreen.main.bounds.width * 0.65,
                   height: 24,
                   alignment: .center)
                .rotationEffect(Angle(degrees: 90.0))
                .scaledToFit()
                .clipped()
                .padding(.vertical, 4)
            
        }
    }
}
