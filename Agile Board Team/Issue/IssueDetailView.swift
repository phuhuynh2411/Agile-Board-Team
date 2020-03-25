//
//  IssueDetailView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueDetailView: View {
    var issue: Issue
    
    var body: some View {
        List  {
            HStack {
                if issue.type?.icon != nil {
                    RemoteImage(stringURL: (issue.type?.icon)!)
                        .frame(width: 16, height: 16, alignment: .center)
                        .foregroundColor(.lightGreyColor)
                } else {
                    IssueTypePlaceholder()
                        .frame(width: 16, height: 16, alignment: .center)
                }
                Text(issue.issueNumber)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            HStack {
                Text(issue.name)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(.lightGreyColor)
                
            }
            
            Button(action: {
                
            }) {
                Text(issue.status?.name.uppercased() ?? "")
                    .padding(EdgeInsets(top: 3, leading: 15, bottom: 3, trailing: 15))
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .background(Color.init(hex: issue.status?.color ?? "cecece"))
                    .cornerRadius(20)
            }
            
            Text(issue.description ?? "")
                .font(.system(size: 17))
            
            if issue.type != nil {
                IssueTypeRow(issueType: issue.type!)
            }
            
            IssueProjectRowView(project: issue.project)
            
            if issue.priority != nil {
                NavigationLink(destination: PriorityListView().environmentObject(PriorityListModel())) {
                    IssuePriorityRowView(priority: issue.priority!)
                }
            }
            if issue.supporter != nil {
                IssueReporterView(reporter: issue.supporter!)
            }
            
            IssueAttachmentRowView()
        }
        
    }
}

struct IssueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IssueDetailView(issue: issueData[0])
    }
}
