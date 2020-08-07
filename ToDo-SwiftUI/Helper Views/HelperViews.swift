//
//  HelperViews.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import Foundation
import SwiftUI

enum GradientTypes: String, CaseIterable, Codable {
    case linear, radient, angular, none
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
    
    case .none:
        return AnyView(EmptyView())
    }
    
}

func getSystemImage(name: String = "photo", color:Color = .primary,
                    fontSize:CGFloat = 20,
                    weight: Font.Weight = .regular , design: Font.Design = .default,
                    scale: Image.Scale = .medium) -> some View {
    
    Image(systemName: name)
        .foregroundColor(color)
        .font(.system(size: fontSize, weight: weight, design: design) )
        .imageScale(scale)
        .padding()
}

func tabItemGroup(text: String, imageName: String, imageScale: Image.Scale = .medium) -> some View {
    
    VStack {
        Text(text)
        getSystemImage(name: imageName, fontSize: 16, scale: imageScale)
    }
    
}

func headerItemGroup(imageName: String, text: String, imageScale: Image.Scale = .small) -> some View {
    
    HStack(spacing: -8) {
        
        getSystemImage(name: imageName, color: Color.primary.opacity(0.5),
                       fontSize: 16, weight: .medium, scale: imageScale)
            .padding(.leading, -14.0)
        Text(text)
    }
    
}

// Taken from hexStringToUIColor: https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values

func hexColor (hex:String) -> Color {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return Color(UIColor.gray)
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return Color(UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0))
    )
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
    var fontSize: CGFloat = 20
    
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            getSystemImage(name: self.systemImageName,
                           color: .primary, fontSize: self.fontSize,
                           scale: .medium).colorInvert()
                .padding(4)
                .background(myGradient(type: .linear, colors: [.red, .purple]))
                .clipShape(Circle())
                .shadow(color: Color.primary.opacity(0.20), radius: 10)
            
        }
        .position(x: UIScreen.main.bounds.width * 0.82,
                  y: UIScreen.main.bounds.height * 0.92 )
        .ignoresSafeArea()
    }
}

struct CustomBarButton: View {
    
    @State var imageName: String = "plus.circle.fill"
    
    var body: some View {
        
        getSystemImage(name: self.imageName, scale: .large)
            .foregroundOverlay(myGradient(type: .linear,
                                          colors: [hexColor(hex: "#4facfe"),
                                                   hexColor(hex: "#00f2fe")]))
            .padding(.horizontal, -12)
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
