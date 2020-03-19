//
//  InfiniteProgressView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

private var timer: Timer?

struct InfiniteProgressView: View {
    
    @State var progressDegree: Double = 10
    @State var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(lineWidth: 3)
                .foregroundColor(.blue)
                .frame(width: 50, height: 50, alignment: .center)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0))
                .padding()
                .onAppear {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        self.isAnimating = true
                    }
                }
        }
    }
}

struct InfiniteProgressView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteProgressView()
    }
}
