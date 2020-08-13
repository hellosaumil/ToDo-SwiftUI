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
    @Binding var isActive: Bool
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 40)
                        .foregroundColor(Color.secondary.opacity(0.06))
                    
                    TextField(message, text: $query)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 36)
                    
                    HStack {
                        Image(systemName: "magnifyingglass").imageScale(.medium)
                            .foregroundColor(Color.secondary.opacity(0.50))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    
                    HStack {
                        
                        Spacer(minLength: 4)
                        
                        Button(action: {
                            withAnimation(.easeInOut) {
                                query = ""
//                                isActive.toggle()
                            }
                        }) {
                            
                            getSystemImage(name: "xmark.circle.fill", color: .secondary, fontSize: 16, weight: .medium, design: .default, scale: .medium)
                                .padding(.horizontal, -6)
                                .padding(.vertical, -12)
                                .opacity(0.20)
                            
                        }
                    }
                    .opacity( (query == "") ? 0 : 1)
                    
                    
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
        
        Group {
            
            ForEach([true, false], id: \.self) { active in
                
                SearchBar(query: .constant(""), isActive: .constant(false))
                    .frame(height: 40).padding(.top, 10)
                    .previewLayout(.sizeThatFits)
                
                SearchBar(query: .constant("Something to search"), isActive: .constant(active))
                    .frame(height: 40).padding(.top, 10)
                    .previewLayout(.sizeThatFits)
                
                SearchBar(query: .constant("Something very very long thing to search if you can and fine if do not :("), isActive: .constant(active))
                    .frame(height: 40).padding(.top, 10)
                    .previewLayout(.sizeThatFits)
            }
        }
    }
}
