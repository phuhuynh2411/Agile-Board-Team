//
//  IssueTypRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueTypeRowForListView: View {
    var issueType: IssueType
    var isSelected = false
    
    var body: some View {
        HStack(spacing: 16) {
            if issueType.icon != nil {
                RemoteImage(stringURL: issueType.icon!)
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            }
            Text(issueType.name)
                .font(.system(size: 17))
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
        }
    }
}

struct IssueTypeRowView_Previews: PreviewProvider {
    static var previews: some View {
        IssueTypeRowForListView(issueType: issueData[0].type!, isSelected: true)
    }
}
