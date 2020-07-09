//
//  ListMasterView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/1/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct ListMasterView: View {
    
    @State var ListTitle: String = "WWDC Watchlist"
    @State var items: [String] = ["Swift Deep Dive", "What's new in SwiftUI",
                                  "App Essentials in SwiftUI", "Unsafe Swift",
                                  "Widets Code-along", "Swan's Quest"]
    
    var body: some View {
        
        NavigationView {
            
            List(items, id: \.self) { item in
                
                NavigationLink(destination: ListDetailView(detailTitle: item)) {
                    
                    ListCellView(item: item)
                        .padding(.leading, -22)
                }
            }
            .navigationBarTitle(Text("👨🏻‍💻 \(self.ListTitle)"), displayMode: .automatic)
        }
    }
}

struct ListMasterView_Previews: PreviewProvider {
    static var previews: some View {
        ListMasterView()
    }
}
