//
//  ListCellView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/1/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListCellView: View {
    
    @State var item: String = "want to-do something"
    
    var body: some View {
        
        HStack {
            
            getSystemImage(name: "hexagon.fill", font: .body)
                .padding(.trailing, -4)
                .foregroundOverlay(
                    myGradient(type: .linear,
                               colors: [.red, .purple]))
            
            
            Text("\(item)")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .foregroundOverlay( myGradient(type: .linear) )
            
        }.padding(.horizontal)
    }
}

struct ListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListCellView()
            .previewLayout(.sizeThatFits)
    }
}
