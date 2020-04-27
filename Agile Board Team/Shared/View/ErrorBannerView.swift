//
//  ErrorBannerView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct ErrorBannerView: View {
    var message: String = ""
    @Binding var display: Bool
    
    var body: some View {
        HStack {
            Text(self.message)
                .foregroundColor(.white)
        
            Spacer()
            Button(action: {
                withAnimation(.easeInOut) {
                    self.display = false
                }
            }) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.darkBlue)
    }
}

struct ErrorBannerView_Previews: PreviewProvider {
    @State static var display: Bool = true
    static var previews: some View {
        Group {
            if self.display { ErrorBannerView(message: "Nullam quis risus eget urna mollis ornare vel eu leo. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", display: $display)
            }
        }
    }
}
