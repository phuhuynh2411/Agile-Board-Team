//
//  IssueRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueRowView: View {
    @ObservedObject var issue: Issue
    
    init(_ issue: Issue){
        self.issue = issue
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if issue.type?.icon != nil {
                RemoteImage(stringURL: (issue.type?.icon)!)
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            } else {
                IssueTypePlaceholder()
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(self.issue.name)
                    .font(.system(size: 17))
                HStack {
                    Text(issue.issueNumber)
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                    // Priority
                    if issue.priority?.icon != nil {
                        RemoteImage(stringURL: (issue.priority?.icon)!)
                            .frame(width: 12, height: 12, alignment: .center)
                            .foregroundColor(.lightGreyColor)
                    } else {
                        PriorityPlaceholder()
                    }
                    Text(issue.status?.name.uppercased() ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
                        .background(Color(hex: issue.status?.color ?? "#cecece"))
                        .cornerRadius(3.0)
                    Spacer()
                    //Text("Due today")
                      //  .font(.system(size: 14))
                        //.foregroundColor(.red)
                }
            }
        }
        .frame(height: 60, alignment: .leading)
        //.padding()
    }
}

//struct IssueRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        IssueRowView(issue: issueData[0])
//    }
//}

struct IssueTypeView: View {
    var stringURL: String
    
    var body: some View {
        RemoteImage(stringURL: stringURL)
            //.resizable()
            .frame(width: 20, height: 20)
            .cornerRadius(7)
    }
}

struct IssueTypePlaceholder: View {
    var body: some View {
        Image(systemName: "doc.plaintext")
            .resizable()
            .frame(width: 20, height: 20, alignment: .center)
    }
}

struct PriorityPlaceholder: View {
    var body: some View {
        Image(systemName: "doc.plaintext")
            .resizable()
            .frame(width: 20, height: 20, alignment: .center)
    }
}
