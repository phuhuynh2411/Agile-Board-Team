//
//  IssuePriorityRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssuePriorityRowView: View {
    @Binding var priority: IssuePriority?
    @Binding var isUpdating: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Priority")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            HStack {
                if priority?.icon != nil {
                    RemoteImage(stringURL: (priority?.icon!)!)
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.lightGreyColor)
                } else {
                    Image(systemName: "photo")
                    .resizable()
                        .frame(width: 16, height: 16, alignment: .center)
                }
                Text(priority!.name)
                    .font(.system(size: 16))
                Spacer()
            }
        }.overlay(
            HStack {
                Spacer()
                ProgressView(isUpdating: self.$isUpdating).padding(.trailing, 16)
            }
        )
    }
}

struct IssuePriorityRowView_Previews: PreviewProvider {
    @State static var isUpdating: Bool = true
    @State static var priority: IssuePriority? = issueData[0].priority
    static var previews: some View {
        IssuePriorityRowView(priority: $priority, isUpdating: $isUpdating)
    }
}

private struct ProgressView: View {
    @Binding var isUpdating: Bool
    
    var body: some View {
        Group {
            if isUpdating {
                InfiniteProgressView()
                .frame(width: 20, height: 20, alignment: .center)
            }
        }
    }
}
