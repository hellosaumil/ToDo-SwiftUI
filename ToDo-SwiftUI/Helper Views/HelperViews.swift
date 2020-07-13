//
//  HelperViews.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import Foundation
import SwiftUI

enum GradientTypes: String, CaseIterable {
    case linear, radient, angular
    var id: String { self.rawValue }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    public func foregroundOverlay<Overlay: View>(_ overlay: Overlay) -> some View {
        self.overlay(overlay).mask(self)
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
    }
    
}

func getSystemImage(name: String = "photo", color:Color = .primary, font:Font = .title, scale: Image.Scale = .medium) -> some View {
    Image(systemName: name)
        .foregroundColor(color)
        .font(font)
        .imageScale(scale)
        .padding()
}

func tabItemGroup(text: String, imageName: String, imageScale: Image.Scale = .medium) -> some View {
    
    VStack {
        Text(text)
        getSystemImage(name: imageName, font: .body, scale: imageScale)
    }
    
}

func headerItemGroup(imageName: String, text: String, imageScale: Image.Scale = .small) -> some View {
    
    HStack(spacing: -8) {
        
        getSystemImage(name: imageName, color: Color.primary.opacity(0.5),
                       font: .headline, scale: imageScale)
            .padding(.leading, -14.0)
        Text(text)
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

struct BindingTextRowView: View {
    
    @Binding var headline: String
    @Binding var subheadline: String
    @Binding var caption: String
    
    var body: some View {
        
        HStack {
            
            Text(self.headline).bold()
            
            Spacer()
            
            if self.caption == "" {
                
                Text("\(self.subheadline)")
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .font(.system(size: 16, design: .monospaced))
                
            } else {
                
                VStack(alignment: .trailing) {
                    
                    Text("\(self.subheadline)")
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .font(.system(size: 16, design: .serif))
                    
                    Text("\(self.caption)")
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .font(.system(size: 14, design: .monospaced))
                    
                }
            }
        }
    }
}


struct FloatingActionButton: View {
    
    var systemImageName: String = "plus"
    @Binding var bgColor: Color
    var color: Color = .white
    var font: Font = .body
    
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            getSystemImage(name: self.systemImageName,
                           color: self.color, font: self.font,
                           scale: .medium)
                .background(self.bgColor)
                .clipShape(Circle())
                .padding(.horizontal)
                .shadow(color: .primary, radius: 8)
        }
    }
}

/// Ref: https://finestructure.co/blog/2020/1/28/enhance-your-swiftui-previews-with-gala
public func NightAndDay<A: View>(_ name: String? = nil,
                                 @ViewBuilder items: @escaping () -> A) -> some View {
    ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
        items()
            .previewDisplayName(name.map { "\($0) \(scheme)" } ?? "\(scheme)")
            .environment(\.colorScheme, scheme)
    }
}
