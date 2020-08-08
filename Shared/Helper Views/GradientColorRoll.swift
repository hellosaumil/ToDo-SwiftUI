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
            
            Text(text).lineLimit(2)
                .scaledToFit()
            
            Spacer()
            
            Picker(selection: $selectedColor, label: EmptyView()) {
                
                ForEach(BaseColors.allCases, id: \.id) { colorName in
                    
                    BaseShapes.square.filled.tag(colorName)
                        .rotationEffect(Angle(degrees: -90.0))
                        .foregroundColor( colorName.color )
                        .imageScale(.medium)
                    
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
            .padding(.leading, -30)
            
        }
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
