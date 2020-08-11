//
//  AppLogoView.swift
//  ToDo-SwiftUI (iOS)
//
//  Created by Saumil Shah on 8/11/20.
//

import SwiftUI

struct AppLogoView: View {
    
    @State private var logoScale: CGFloat = 1.2
    
    var body: some View {
        
        Group {
            
            getSystemImage(name: "list.star", color: .pink,
                           fontSize: 110*logoScale, weight: .medium,
                           design: .rounded, scale: .medium)
                .foregroundOverlay(myGradient(type: .linear, colors: [.pink, .purple]))
                .shadow(color: Color.purple.opacity(0.25) , radius: 4, x: 2, y: 4)
            
        }
        .frame(width: 150*logoScale, height: 150*logoScale, alignment: .center)
        .background(Color.pink.opacity(0.02))
    }
}

struct AppLogoView_Previews: PreviewProvider {
    static var previews: some View {
        AppLogoView()
            .previewLayout(.sizeThatFits)
    }
}
