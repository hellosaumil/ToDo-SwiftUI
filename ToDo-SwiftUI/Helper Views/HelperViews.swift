//
//  HelperViews.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import Foundation
import SwiftUI

enum GradientTypes {
    case linear, radient, angular
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
    }
    
}



func getSystemImage(_ systemName: String = "photo", font:Font = .body, color:Color = .primary) -> some View {
    
    getSystemImage(systemName, color, font)
}

func getSystemImage(_ systemName: String = "photo", _ color:Color = .primary, _ font:Font = .title, scale: Image.Scale = .medium) -> some View {
    Image(systemName: systemName)
        .foregroundColor(color)
        .font(font)
        .imageScale(scale)
        .padding()
}

func tabItemGroup(itemText: String, systemName: String) -> some View {
    
    VStack {
        Text(itemText)
        getSystemImage(systemName, font: .body)
    }
    
}

struct RoundedButton: View {
    
    @State var text: String
    @State var color: Color = .accentColor
    @State var foregroundColor: Color = .white
    @State var font:Font = .body
    @State var scale: CGFloat = 1.0
    
    var body: some View {
        Text(self.text)
            .font(font)
            .fontWeight(.semibold)
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.88 * self.scale )
            .foregroundColor(foregroundColor)
            .background(color)
            .cornerRadius(14)
    }
}
