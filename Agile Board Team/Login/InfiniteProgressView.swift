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
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(lineWidth: 3)
                .foregroundColor(.blue)
                .frame(width: 50, height: 50, alignment: .center)
                .rotationEffect(.degrees(progressDegree))
                .padding()
        }.onAppear {
            self.start()
        }.onDisappear {
            self.stop()
        }
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { (timer) in
            withAnimation {
                self.progressDegree += 10
            }
            if self.progressDegree >= 360 {
                self.progressDegree = 0
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
    }
}

struct InfiniteProgressView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteProgressView()
    }
}
