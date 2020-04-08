//
//  InfiniteProgressView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct InfiniteProgressView: View {
    
    @State var isAnimating = false
    //@State var duration = 0.8
    @State var trim1: (CGFloat, CGFloat) = (0, 0.25)
    @State var trim2: (CGFloat, CGFloat) = (0.5, 0.75)
    
    @State private var rotationDegree = 0.0
    private var timeCurveAnimation: Animation {
        return Animation.timingCurve(0.6, 0.4, 0.4, 0.4, duration: 1.5)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .trim(from: trim1.0, to: trim1.1)
                    .stroke(lineWidth: 3)
                    .foregroundColor(.circleGray)
                    //.frame(width: 30, height: 30, alignment: .center)
                
                Circle()
                    .trim(from: trim2.0, to: trim2.1)
                    .stroke(lineWidth: 3)
                    .foregroundColor(.circleGray)
                    //.frame(width: 30, height: 30, alignment: .center)
            }
        }
        .rotationEffect(.degrees(rotationDegree))
        .onAppear() {
            withAnimation(self.timeCurveAnimation) {
                self.rotationDegree = 1080.0
            }
        }
    }
}

struct InfiniteProgressView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteProgressView()
    }
}
