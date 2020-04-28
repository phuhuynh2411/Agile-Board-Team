//
//  TextView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var isScrollEnabled: Bool = true
    var font: UIFont? = UIFont.systemFont(ofSize: 17)
    var size: Binding<CGSize>?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let uiTextView = UITextView()
        uiTextView.isScrollEnabled = self.isScrollEnabled
        uiTextView.text = self.text
        uiTextView.font = self.font
        // remove all UITextView's padding
        uiTextView.textContainerInset = .zero
        uiTextView.textContainer.lineFragmentPadding = 0
        // add text view delegate
        uiTextView.delegate = context.coordinator
        
        return uiTextView
    }
    
    func updateUIView(_ uiTextView: UITextView, context: Context) {
        uiTextView.text = self.text
        DispatchQueue.main.async {
            self.size?.wrappedValue = uiTextView.contentSize
        }        
    }
    
    typealias UIViewType = UITextView
    
    class Coordinator: NSObject, UITextViewDelegate {
        let control: TextView
        
        init(_ control: TextView) {
            self.control = control
        }
        
        func textViewDidChange(_ uiTextView: UITextView) {
            control.text = uiTextView.text
        }
    }
}
