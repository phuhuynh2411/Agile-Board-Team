//
//  IssueDetailView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueDetailView: View {
    @EnvironmentObject var modelView: IssueDetailModel
    
    var body: some View {
        List  {
            HStack {
                if modelView.issue.type?.icon != nil {
                    RemoteImage(stringURL: (modelView.issue.type?.icon)!)
                        .frame(width: 16, height: 16, alignment: .center)
                        .foregroundColor(.lightGreyColor)
                } else {
                    IssueTypePlaceholder()
                        .frame(width: 16, height: 16, alignment: .center)
                }
                Text(modelView.issue.issueNumber)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            HStack {
                Text(modelView.issue.name)
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
                Text(modelView.issue.status?.name.uppercased() ?? "")
                    .padding(EdgeInsets(top: 3, leading: 15, bottom: 3, trailing: 15))
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .background(Color.init(hex: modelView.issue.status?.color ?? "cecece"))
                    .cornerRadius(20)
            }
            
            Text(modelView.issue.description ?? "")
                .font(.system(size: 17))
            
            if modelView.issue.type != nil {
                IssueTypeRow(issueType: modelView.issue.type!)
            }
            
            IssueProjectRowView(project: modelView.issue.project)
            
            PriorityRow
            
            if modelView.issue.supporter != nil {
                IssueReporterView(reporter: modelView.issue.supporter!)
            }
            
            IssueAttachmentRowView()
        }
        
    }
    
    private var PriorityRow: some View {
        Group {
            NavigationLink(destination: PriorityListView(priority:  self.$modelView.issue.priority)
                .environmentObject(PriorityListModel())) {
                    IssuePriorityRowView(priority: self.$modelView.issue.priority)
            }
        }
    }
}

struct IssueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IssueDetailView().environmentObject(IssueDetailModel(issue: issueData[0]))
    }
}
