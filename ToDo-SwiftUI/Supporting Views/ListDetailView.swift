//
//  ListDetailView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 6/24/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI


var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}

enum BaseColors: String, CaseIterable, Identifiable {
    
    case orange, pink, yellow, green, blue, purple
    var id: String { self.rawValue }
    
    var color: Color {
        
        switch self {
            
        case .orange: return .orange
        case .pink: return .pink
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
            
            //        default:
            //            return .primary
        }
    }
}


struct ListDetailView: View {
    
    @State var detailTitle: String = "In Detail"
    
    @State private var eventDate = Date()
    @State private var eventTime = Date()
    
    @State private var selectedColor:BaseColors = .pink
    
    var body: some View {
        
        VStack {
            
            Form {
                
                Section(header: Text("Reminde me on the")) {
                    
                    DatePicker(selection: $eventDate,
                               in: Date()...,
                               displayedComponents: .date,
                               label: {Text("Date")} )
                    
                    
                    DatePicker(selection: $eventTime,
                               in: Date()...,
                               displayedComponents: .hourAndMinute,
                               label: {Text("Time")} )
                    
                }
                
                Section(header: Text("More details")) {
                    
                    TextFieldView(title: "Notes",
                                  text: .constant(""),
                                  placeholder: "Note here so you don't forget...",
                                  backgroundColor: Color.primary.opacity(0.05))
                        .frame(height: 160)
                        .padding(.vertical)
                    
                    HStack {
                        getSystemImage("star",
                                       font: .body,
                                       color: .yellow)
                        
                        Text("Add to Favorites")
                    }
                }
                
                Section(header:
                    HStack {
                        
                        getSystemImage("paintbrush.fill",
                                       font: .caption,
                                       color: selectedColor.color)
                            .padding(.horizontal, -16)
                        
                        Text("Customize")
                        
                }) {

                    Picker(selection: $selectedColor, label: Text("")) {
                        ForEach(BaseColors.allCases, id: \.id) { colorName in
                            Text(colorName.rawValue).tag(colorName)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical)
                }
            }
            
            Spacer()
            Divider()
            
            Button(action: {}) {
                
                RoundedButton(text: "Save Changes")
            }
            .padding(.top, 8)
            
        }
        .navigationBarTitle(Text("\(detailTitle)"))
    }
    
    private func endEditing(_ force: Bool) {
        UIApplication.shared.endEditing()
    }
    
}

struct ListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailView()
    }
}

struct TextFieldView: View {
    
    @State var title: String = "TextField"
    @Binding var text: String
    @State var placeholder: String = "Text here..."
    
    @State var backgroundColor:Color = Color.primary.opacity(0.05)
    @State var cornerRadius:CGFloat = 10
    @State var size:CGFloat = 14
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            MultiLineTF(text: $text,
                        placeholder: placeholder,
                        fontSize: size)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}

struct MultiLineTF : UIViewRepresentable {
    
    
    func makeCoordinator() -> MultiLineTF.Coordinator {
        
        return MultiLineTF.Coordinator(parent1: self)
    }
    
    
    @Binding var text : String
    @State var placeholder: String = "Type Something"
    @State var fontSize : CGFloat = 14
    
    func makeUIView(context: UIViewRepresentableContext<MultiLineTF>) -> UITextView{
        
        let view = UITextView()
        
        if self.text != ""{
            
            view.text = self.text
            view.textColor = .black
        }
        else{
            
            view.text = self.placeholder
            view.textColor = .gray
        }
        
        
        view.font = .systemFont(ofSize: fontSize)
        
        
        view.isEditable = true
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTF>) {
        
    }
    
    class Coordinator : NSObject,UITextViewDelegate{
        
        var parent : MultiLineTF
        
        init(parent1 : MultiLineTF) {
            
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            if self.parent.text == ""{
                
                textView.text = ""
                textView.textColor = .black
            }
            
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            self.parent.text = textView.text
        }
    }
}
