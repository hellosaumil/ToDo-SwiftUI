//
//  ListDetailView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI


var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}

enum BaseColors: String, CaseIterable, Identifiable {
    
    case pink, yellow, orange, green, blue, purple
    var id: String { self.rawValue }
    
    var color: Color {
        
        switch self {
            
        case .pink: return .pink
        case .yellow: return .yellow
        case .orange: return .orange
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
            
            //        default:
            //            return .primary
        }
    }
}

enum BaseShapes: String, CaseIterable, Identifiable {
    
    case triangle, square, rectangle, hexagon, circle, capsule, shield
    var id: String { self.rawValue }
    
    var unfilled:Image { return Image(systemName: "\(self.id)") }
    var filled:Image { return Image(systemName: "\(self.id).fill") }
}


struct ListDetailView: View {
    
    @State var detailTitle: String = "In Detail"
    
    @State private var eventDate = Date()
    @State private var eventTime = Date()
    
    @State private var selectedColor:BaseColors = .orange
    @State private var selectedShape:BaseShapes = .hexagon
    
    @State private var isMyFavorite:Bool = false
    
    
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
    
    private func endEditing(_ force: Bool) {
        UIApplication.shared.endEditing()
    }
    
}

struct ListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailView()
    }
}
