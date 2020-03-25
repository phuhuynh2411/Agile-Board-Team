//
//  IssuePriorityRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssuePriorityRowView: View {
    var priority: IssuePriority
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Priority")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            HStack {
                if priority.icon != nil {
                    RemoteImage(stringURL: priority.icon!)
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.lightGreyColor)
                } else {
                    Image(systemName: "photo")
                    .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                }
                Text(priority.name)
                    .font(.system(size: 16))
                Spacer()
            }
        }
    }
}

struct IssuePriorityRowView_Previews: PreviewProvider {
    static var previews: some View {
        IssuePriorityRowView(priority: issueData[0].priority!)
    }
}
