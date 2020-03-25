//
//  PriorityRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct PriorityRowView: View {
    var priority: IssuePriority
    
    var body: some View {
        HStack(spacing: 16) {
            if priority.icon != nil {
                RemoteImage(stringURL: priority.icon!)
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            }
            Text(priority.name)
                .font(.system(size: 17))
            
            Spacer()
        }
    }
}

struct PriorityRowView_Previews: PreviewProvider {
    static var previews: some View {
        PriorityRowView(priority: issueData[0].priority!)
    }
}
