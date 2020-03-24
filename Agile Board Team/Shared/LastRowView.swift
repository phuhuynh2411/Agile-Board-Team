//
//  LastRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct LastRowView: View {
    
    @Binding var isLoadingMore: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 70)
                .foregroundColor(.white)
            if self.isLoadingMore {
                InfiniteProgressView().id(UUID().uuidString)
            }
        }
    }
}


struct LastRowView_Previews: PreviewProvider {
    @State static var isLoadingMore = true
    static var previews: some View {
        LastRowView(isLoadingMore: $isLoadingMore)
    }
}
