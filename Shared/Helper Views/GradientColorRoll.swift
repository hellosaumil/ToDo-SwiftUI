//
//  GradientColorRoll.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import SwiftUI

enum GradientTypes: String, CaseIterable, Codable {
    case linear, radient, angular
    var id: String { rawValue }
}


struct GradientColorRoll: View {
    
    @State var text: String = "Choose Color"
    @Binding var selectedColor: BaseColors
    
    // Local state for ColorPicker
    @State private var pickerColor: Color = .orange
    
    var body: some View {
        
        HStack {
            
            Text(text)
            
            Spacer()
            
            // Native ColorPicker (ColorWell)
            ColorPicker("", selection: $pickerColor, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 44, height: 28)
                .onChange(of: pickerColor) { newColor in
                    // Find closest BaseColor match
                    selectedColor = closestBaseColor(to: newColor)
                }
        }
        .padding(.vertical, 4)
        .onAppear {
            pickerColor = selectedColor.color
        }
    }
    
    // Find the closest BaseColor to the selected color
    private func closestBaseColor(to color: Color) -> BaseColors {
        // For simplicity, return the current selection
        // A more sophisticated approach would compare RGB values
        for baseColor in BaseColors.allCases {
            if baseColor.color.description == color.description {
                return baseColor
            }
        }
        return selectedColor
    }
}

struct GradientColorRoll_Previews: PreviewProvider {
    static var previews: some View {
        GradientColorRoll(text: "Gradient", selectedColor: .constant(BaseColors.allCases.first!))
    }
}


func myGradient(
    
    type: GradientTypes, colors: [Color] = [.red, .orange],
    
    startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom,
    center: UnitPoint = .center,
    startAngle: Angle = .zero, endAngle: Angle = .degrees(360),
    startRadius: CGFloat = 2, endRadius: CGFloat = 650
    
) -> AnyView {
    
    switch type {
        
    case .linear:
        return AnyView(LinearGradient(
            gradient: .init(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        
    case .angular:
        return AnyView(AngularGradient(
            gradient: .init(colors: colors),
            center: center,
            startAngle: startAngle,
            endAngle: endAngle
        ))
        
        
    case .radient:
        return AnyView(RadialGradient(
            gradient: .init(colors: colors),
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        ))
    
//    case .none:
//        return AnyView(EmptyView())
    }
    
}
