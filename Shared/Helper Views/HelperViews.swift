//
//  HelperViews.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/8/20.
//

import Foundation
import SwiftUI
import UIKit

//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}

extension String {
    
    var strip: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removeWhitespaces() -> String {
        return replacingOccurrences(of: "\\s", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
    }
}

extension View {
    public func foregroundOverlay<Overlay: View>(_ overlay: Overlay) -> some View {
        self.overlay(overlay).mask(self)
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
        Text(text)
            .font(font)
            .fontWeight(.semibold)
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.88 * scale )
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
            
            Text(headline).bold()
            
            Spacer()
            
            if caption == "" {
                
                Text("\(subheadline)")
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .font(.system(size: 16, design: .monospaced))
                
            } else {
                
                VStack(alignment: .trailing) {
                    
                    Text("\(subheadline)")
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .font(.system(size: 16, design: .serif))
                    
                    Text("\(caption)")
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
            
            getSystemImage(name: systemImageName,
                           color: .primary, fontSize: fontSize,
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
        
        getSystemImage(name: imageName, scale: .large)
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


func iconUserInput(keyboard keyboardDataType: UIKeyboardType = .default, placeholder tf_msg:String="Placeholder Message", textfield tfTextBinding:Binding<String>, lineLimit:Int = 1, fontDesign:Font.Design = .monospaced, fontSize:Font.TextStyle = .body, scale: CGFloat = 1.0) -> some View {
    
    TextField(tf_msg, text: tfTextBinding, onEditingChanged: { _ in
        
        tfTextBinding.wrappedValue = tfTextBinding.wrappedValue.getLast()
        
    })
    // MARK: TODO UISCreen Mishap, keyboardDataType
    //        .frame(width: UIScreen.main.bounds.width * 0.88 * scale, height: 10*CGFloat(lineLimit))
    .lineLimit(lineLimit)
    .font(.system(fontSize, design: fontDesign))
//    .keyboardType(keyboardDataType)
    .fixedSize(horizontal: false, vertical: true)
    
}

func commonUserInput(keyboard keyboardDataType: UIKeyboardType = .default, placeholder tf_msg:String="Placeholder Message", textfield tfTextBinding:Binding<String>, lineLimit:Int = 1, fontDesign:Font.Design = .monospaced, fontSize:Font.TextStyle = .body, scale: CGFloat = 1.0) -> some View {
    
    TextField(tf_msg, text: tfTextBinding, onEditingChanged: { _ in
        
        tfTextBinding.wrappedValue = tfTextBinding.wrappedValue.strip
        
    })
    // MARK: TODO UISCreen Mishap
    //        .frame(width: UIScreen.main.bounds.width * 0.88 * scale, height: 10*CGFloat(lineLimit))
    .lineLimit(lineLimit)
    .font(.system(fontSize, design: fontDesign))
    .keyboardType(keyboardDataType)
    .fixedSize(horizontal: false, vertical: true)
    
}

