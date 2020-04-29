//
//  IssueAssigneeRowForListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/29/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueAssigneeRowForListView: View {
    @ObservedObject var user: User
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            if user.avatar != nil {
                RemoteImage(stringURL: user.avatar!)
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            }
            Text(user.name)
            
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
        }
    }
}

struct IssueAssigneeRowForListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            IssueAssigneeRowForListView(user: userData[0])
            IssueAssigneeRowForListView(user: userData[1], isSelected: true)
        }
       
    }
}
