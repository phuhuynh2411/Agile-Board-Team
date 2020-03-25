//
//  IssueTypeRow.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueTypeRow: View {
    var issueType: IssueType
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Issue Type")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            HStack {
                if issueType.icon != nil {
                    RemoteImage(stringURL: issueType.icon!)
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.lightGreyColor)
                } else {
                    Image(systemName: "photo")
                    .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                }
                Text(issueType.name)
                    .font(.system(size: 16))
                Spacer()
            }
        }
    }
}

struct IssueTypeRow_Previews: PreviewProvider {
    static var previews: some View {
        IssueTypeRow(issueType: issueData[0].type!)
    }
}
