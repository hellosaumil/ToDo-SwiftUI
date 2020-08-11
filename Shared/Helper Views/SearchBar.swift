//
//  SearchBar.swift
//  ToDo-SwiftUI (iOS)
//
//  Created by Saumil Shah on 8/10/20.
//

import SwiftUI

struct SearchBar: View {
    
    @State var message: String = "Search here..."
    @Binding var query: String
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 40)
                        .foregroundColor(Color.secondary.opacity(0.06))
                    
                    TextField(message, text: $query)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .keyboardType(.twitter)
                        .padding(.horizontal, 10)
                    
                    ZStack {
                        
                        HStack {
                            
                            Spacer(minLength: 4)
                            
                            Button(action: { withAnimation{query = ""} }) {
                                
                                getSystemImage(name: "xmark.circle.fill", color: .secondary, fontSize: 18, weight: .medium, design: .default, scale: .medium)
                                    .padding(.horizontal, -6)
                                    .padding(.vertical, -12)
                                    .opacity(0.20)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 20)
                
                Divider()
                
            }
            .background(Color.primary.colorInvert())
            
            Spacer()
        }
        .padding(.top, 5)
    }
    
}


struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(query: .constant(""))
    }
}
