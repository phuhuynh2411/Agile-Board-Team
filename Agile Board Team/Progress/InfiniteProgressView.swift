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
    
    @State var isAnimating = false
    @State var dash: CGFloat = 20
    
    var body: some View {
        VStack {
            Circle()
                .strokeBorder(
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round,
                        dash: [self.dash]
                        
                    ), antialiased: false
                )
                .foregroundColor(.circleGray)

                .frame(width: 30, height: 30, alignment: .center)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0))
                .padding()
                .onAppear {
                    withAnimation(Animation.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                        self.isAnimating = true
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                        self.dash = self.dash == 20 ? 10 : 20
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
