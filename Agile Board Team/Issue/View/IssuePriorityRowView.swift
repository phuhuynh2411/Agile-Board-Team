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
        HStack(spacing: 16) {
            self.icon
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Priority")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                Text(priority.name)
                    .font(.system(size: 16))
            }
            Spacer()
        }
    }
    
    private var icon: some View {
        guard let url = priority.icon else {
            return AnyView(Image(systemName: "photo")
            .resizable()
            .frame(width: 25, height: 25, alignment: .center))
        }
        
        return AnyView(RemoteImage(stringURL: url)
        .frame(width: 25, height: 25, alignment: .center)
        .foregroundColor(.lightGreyColor))
    }
}

struct IssuePriorityRowView_Previews: PreviewProvider {
    static var priority: IssuePriority = issueData[0].priority!
    static var previews: some View {
        IssuePriorityRowView(priority: priority)
    }
}
