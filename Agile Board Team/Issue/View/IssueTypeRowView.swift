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
    var issueType: IssueType?
    var isUpdating: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            if issueType?.icon != nil {
                RemoteImage(stringURL: (issueType?.icon!)!)
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Issue Type")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Text(issueType?.name ?? "")
                    .font(.system(size: 16))
               // Spacer()
            }
            Spacer()

        }
        .overlay(
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

struct IssueTypeRow_Previews: PreviewProvider {
    static var isUpdating: Bool = true
    static var issueType: IssueType? = issueData[0].type
    
    static var previews: some View {
        IssueTypeRowView(issueType: self.issueType, isUpdating: self.isUpdating)
    }
}
