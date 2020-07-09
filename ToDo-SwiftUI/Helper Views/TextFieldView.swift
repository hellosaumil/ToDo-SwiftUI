//
//  TextFieldView.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 7/8/20.
//  Copyright © 2020 Saumil Shah. All rights reserved.
//

import SwiftUI

struct TextFieldView: View {
    
    @State var title: String = "TextField"
    @Binding var text: String
    @State var placeholder: String = "Text here..."
    
    @State var backgroundColor:Color = Color.primary.opacity(0.05)
    @State var cornerRadius:CGFloat = 10
    @State var size:CGFloat = 14
    
    @State var verticalFlag: Bool = true
    
    
    ///https://stackoverflow.com/questions/56517610/
    ///conditionally-use-view-in-swiftui
    @ViewBuilder
    var body: some View {
        
        
        if self.verticalFlag {
            
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
            
        } else {
                  
            HStack(alignment: .center) {
                
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
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(text: .constant("some text"))
            .previewLayout(.sizeThatFits)
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

func commonUserInput(keyboard keyboardDataType: UIKeyboardType = .default, placeholder tf_msg:String="Placeholder Message", textfield tfTextBinding:Binding<String>, lineLimit:Int = 1, fontDesign:Font.Design = .monospaced, fontSize:Font.TextStyle = .body, scale: CGFloat = 1.0) -> some View {
    
    
    TextField(tf_msg, text: tfTextBinding, onEditingChanged: { _ in
        
        tfTextBinding.wrappedValue = tfTextBinding.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
    })
        .frame(width: UIScreen.main.bounds.width * 0.88 * scale, height: 10*CGFloat(lineLimit))
        .lineLimit(lineLimit)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .font(.system(fontSize, design: fontDesign))
        .keyboardType(keyboardDataType)
    
    
}
