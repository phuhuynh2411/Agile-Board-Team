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
        List {
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
           
            NameView(name: $modelView.issue.name)
            
            Button(action: {
                
            }) {
                Text(modelView.issue.status?.name.uppercased() ?? "")
                    .padding(EdgeInsets(top: 3, leading: 15, bottom: 3, trailing: 15))
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .background(Color.init(hex: modelView.issue.status?.color ?? "cecece"))
                    .cornerRadius(20)
            }
            
            DescriptionView(description: $modelView.issue.description)
            
            IssueTypeRow
            
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
            NavigationLink(destination: PriorityListView()
                .environmentObject(PriorityListModel())) {
                    IssuePriorityRowView(priority: self.$modelView.issue.priority, isUpdating: self.$modelView.isUpdatingPriority)
            }
        }
    }
    
    private var IssueTypeRow: some View {
        Group {
            NavigationLink(destination: IssueTypeListView()
                .environmentObject(IssueTypeListModel())) {
                    IssueTypeRowView(issueType: self.$modelView.issue.type, isUpdating: self.$modelView.isUpdatingIssueType)
            }
        }
    }

}

struct IssueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IssueDetailView().environmentObject(IssueDetailModel(issue: issueData[0]))
    }
}

struct NameView: View {
    @Binding var name: String
    
    var body: some View {
        HStack {
            Text(self.name)
                .font(.system(size: 17))
                .fontWeight(.semibold)
            Spacer()
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.lightGreyColor)
            
        }
    }
}

struct DescriptionView: View {
    @Binding var description: String?
    
    var body: some View {
        Text(description ?? "")
                     .font(.system(size: 17))
    }
}
