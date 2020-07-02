//
//  ListDetailView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

extension View {
    public func foregroundOverlay<Overlay: View>(_ overlay: Overlay) -> some View {
        self.overlay(overlay).mask(self)
    }
}


struct ListDetailView: View {
    
    @State var ListTitle: String = "WWDC Watchlist"
    @State var items: [String] = ["Swift Deep Dive", "What's new in SwiftUI",
                                  "App Essentials in SwiftUI", "Unsafe Swift",
                                  "Widets Code-along", "Swan's Quest"]
    
    var body: some View {
        
        NavigationView {
            
            Group {
                
                List(items, id: \.self) { item in
                    
                    ListCell(item: item)
                }
                
            }
            .navigationBarTitle(Text("👨🏻‍💻 \(self.ListTitle)"), displayMode: .automatic)
        }
    }
}

struct ListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailView()
    }
}


struct ListCell: View {
    
    @State var item: String = "Want to-do something"
    
    var body: some View {
        
        HStack {
            
            getSystemImage("hexagon.fill", font: .body)
                .padding(.leading, -8)
                .padding(.trailing, -4)
                .foregroundOverlay(
                    myGradient(type: .linear,
                               colors: [.red, .purple]))
            
            
            Text("\(item)")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .foregroundOverlay( myGradient(type: .linear) )
            
        }
    }
}
