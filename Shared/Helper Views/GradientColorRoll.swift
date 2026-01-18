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
    
    var body: some View {
        
        HStack {
            
            Text(text)
            
            Spacer()
            
            // Color swatch preview
            RoundedRectangle(cornerRadius: 6)
                .fill(selectedColor.color)
                .frame(width: 44, height: 28)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
                )
            
            // Picker with menu style for proper binding
            Picker("", selection: $selectedColor) {
                ForEach(BaseColors.allCases, id: \.self) { colorName in
                    HStack {
                        Circle()
                            .fill(colorName.color)
                            .frame(width: 16, height: 16)
                        Text(colorName.id.capitalized)
                    }
                    .tag(colorName)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
        .padding(.vertical, 4)
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
