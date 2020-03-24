//
//  CircleProgressView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct CircleProgressView: View {
    @Binding var display: Bool
    
    var body: some View {
        Group {
            if display {
                InfiniteProgressView()
            }
        }
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    @State static var display = true
    static var previews: some View {
        CircleProgressView(display: $display)
    }
}
