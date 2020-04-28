//
//  IssueStatusRowForListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueStatusRowForListView: View {
    var issueStatus: IssueStatus
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            //self.icon
            RoundedRectangle(cornerRadius: 7)
                .frame(width: 30, height: 30)
                .foregroundColor(Color.init(hex: issueStatus.color))
            
            Text(issueStatus.name)
                .font(.system(size: 17))
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
        }
    }
    
    private var icon: some View {
        guard let url = issueStatus.icon else {
            return AnyView(Image(systemName: "photo")
            .resizable()
            .frame(width: 20, height: 20, alignment: .center)
            .foregroundColor(.lightGreyColor))
        }
        
        return AnyView(RemoteImage(stringURL: url)
        .frame(width: 20, height: 20, alignment: .center)
        .foregroundColor(.lightGreyColor))
    }
    
}

struct IssueStatusRowForListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            IssueStatusRowForListView(issueStatus: issueStatusData[0], isSelected: true)
            IssueStatusRowForListView(issueStatus: issueStatusData[1], isSelected: false)
        }
    }
}
