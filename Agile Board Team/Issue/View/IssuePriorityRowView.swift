//
//  IssuePriorityRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssuePriorityRowView: View {
    var priority: IssuePriority?
    var isUpdating: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            if priority?.icon != nil {
                RemoteImage(stringURL: (priority?.icon!)!)
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Priority")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                Text(priority!.name)
                    .font(.system(size: 16))
            }
            Spacer()
        }.overlay(
            HStack {
                Spacer()
                if self.isUpdating {
                    InfiniteProgressView()
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding(.trailing, 16)
                }
            }
        )
    }
}

struct IssuePriorityRowView_Previews: PreviewProvider {
    static var isUpdating: Bool = true
    static var priority: IssuePriority? = issueData[0].priority
    static var previews: some View {
        IssuePriorityRowView(priority: priority, isUpdating: isUpdating)
    }
}
