//
//  RefreshView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/20/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct RefreshView: View {
    @State private var isRefreshing: Bool = false
    var refreshingPublisher: Published<Bool>.Publisher
    
    var body: some View {
        ZStack {
            if self.isRefreshing {
                InfiniteProgressView()
                    .frame(width: 30, height: 30, alignment: .center)
                    .transition(.scale)
            }
        }
        .onReceive(self.refreshingPublisher) { (value) in
            withAnimation(value ? Animation.easeInOut.delay(1) : Animation.easeInOut) {
                self.isRefreshing = value
            }
        }
    }
}
