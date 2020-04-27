//
//  PlaceholderTextView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct PlaceholderTextView: View {
    @Binding var text: String
    var isScrollEnabled: Bool = true
    var font: UIFont? = UIFont.systemFont(ofSize: 17)
    
    var placeholder: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextView(text: $text, font: UIFont.systemFont(ofSize: 17))
                .frame(height: 100)
            if text.isEmpty {
                Text(self.placeholder)
                    .foregroundColor(.secondary)
                    .offset(x: 5, y: 5)
            }
        }
    }
}

struct PlaceholderTextView_Previews: PreviewProvider {
    @State static var text: String = "This is a testing"
    static var previews: some View {
        PlaceholderTextView(text: $text, placeholder: "Type something...")
    }
}
