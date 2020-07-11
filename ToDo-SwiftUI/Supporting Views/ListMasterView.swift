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

            VStack {

                ForEach(items, id: \.self) { item in

                    VStack {

                    ZStack(alignment: .leading) {

                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .foregroundColor(.primary).colorInvert()
                            .shadow(color: Color.primary.opacity(0.20),
                                    radius: 4, x: 2, y: 4)

                        HStack {

                            ListCellView(item: item)

                            Spacer()

                            NavigationLink(destination: ListDetailView(taskName: item)) {

                                getSystemImage(name: "chevron.right", color: Color.primary.opacity(0.35),
                                               font: .callout, scale: .medium)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 60)

                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)

                    }
                }

                Spacer()
            }
            .padding(.vertical)
            .navigationBarTitle(Text("👨🏻‍💻 \(self.ListTitle)"), displayMode: .automatic)
        }
    }
}

struct ListMasterView_Previews: PreviewProvider {
    static var previews: some View {

        NightAndDay {
            ListMasterView()
        }
    }
}
