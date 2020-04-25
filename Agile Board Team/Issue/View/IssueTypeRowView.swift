//
//  IssueTypeRow.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

struct IssueTypeRowView: View {
    var issueType: IssueType
    
    var body: some View {
        HStack(spacing: 16) {
            self.iconView
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Issue Type")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Text(issueType.name)
                    .font(.system(size: 16))
            }
            Spacer()

        }
    }
    
    private var iconView: some View {
        guard let url = self.issueType.icon else {
            return AnyView(Image(systemName: "photo")
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)) }
        
        return AnyView(RemoteImage(stringURL: url)
            .frame(width: 25, height: 25, alignment: .center)
            .foregroundColor(.lightGreyColor))
    }
}

//struct IssueTypeRow_Previews: PreviewProvider {
//    static var isUpdating: Bool = true
//    static var issueType: IssueType? = issueData[0].type
//    
//    static var previews: some View {
//        IssueTypeRowView(issueType: self.issueType, isUpdating: self.isUpdating)
//    }
//}
