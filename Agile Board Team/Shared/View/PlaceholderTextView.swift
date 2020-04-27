//
//  PlaceholderTextView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct PlaceholderTextView: View {
    var placeholder: String = ""
    @Binding var text: String
    var isScrollEnabled: Bool = true
    var font: UIFont? = UIFont.systemFont(ofSize: 17)
    var size: Binding<CGSize>?
    
    init(_ placeholder: String = "", text: Binding<String>, isScrollEnabled: Bool = true, font: UIFont = UIFont.systemFont(ofSize: 17), size: Binding<CGSize>? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.isScrollEnabled = isScrollEnabled
        self.font = font
        self.size = size
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextView(text: $text, isScrollEnabled: self.isScrollEnabled, font: self.font, size: self.size)
            if text.isEmpty {
                Text(self.placeholder)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PlaceholderTextView_Previews: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        PlaceholderTextView("Type something...", text: $text)
    }
}
