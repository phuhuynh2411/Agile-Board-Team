//
//  IssueDetailView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Combine
import SwiftUI

struct IssueDetailView: View {
    @EnvironmentObject var modelView: IssueDetailModel
    @ObservedObject var issue: Issue
    
    
    var body: some View {
        List {
            HStack {
                self.iconView
                Text(issue.issueNumber)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            TitleButtonView(name: issue.name)
            
            StatusButtonView(status: issue.status)

            DescriptionButtonView(description: issue.description)

            NavigationLink(destination: IssueTypeListView()
                .environmentObject(IssueTypeListModel(issue: self.modelView.issue))) {
                    self.modelView.issue.type.map { IssueTypeRowView(issueType: $0) } // Unwrap optional issue type
            }

            IssueProjectRowView(project: issue.project)
//
//            NavigationLink(destination: PriorityListView()
//                .environmentObject(PriorityListModel())) {
//                    IssuePriorityRowView(priority: self.modelView.issue.priority, isUpdating: self.$modelView.isUpdatingPriority)
//            }

//            if modelView.issue.supporter != nil {
//                IssueReporterView(reporter: modelView.issue.supporter!)
//            }
            
            IssueAttachmentRowView()
        }
        
        
    }
    
    private var iconView: some View {
        guard let url = issue.type?.icon else {
            return AnyView(IssueTypePlaceholder()
            .frame(width: 16, height: 16, alignment: .center) )
        }
        
        return AnyView(RemoteImage(stringURL: url)
                .frame(width: 16, height: 16, alignment: .center)
                .foregroundColor(.lightGreyColor))
    }
}

//struct IssueDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        IssueDetailView(o)//.environmentObject(IssueDetailModel(issue: issueData[0]))
//    }
//}

struct TitleButtonView: View {
    var name: String
    @State private var showDetail: Bool = false
    
    var body: some View {
        Button(action: {
            self.showDetail = true
        }) {
            TitleView(name: name)
        }.sheet(isPresented: $showDetail) {
            IssueTitleDescriptionView()
        }
    }
}

struct TitleView: View {
    var name: String
    
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

struct DescriptionButtonView: View {
    var description: String?
    @State private var showDetail: Bool = false
    
    var body: some View {
        Button(action: {
            self.showDetail = true
        }) {
            DescriptionView(description: description)
        }.sheet(isPresented: $showDetail) {
            IssueTitleDescriptionView()
        }
    }
}

struct DescriptionView: View {
    var description: String?
    
    var body: some View {
        Text(description ?? "")
                     .font(.system(size: 17))
    }
}

struct StatusButtonView: View {
    var status: IssueStatus?
    
    var body: some View {
        Button(action: { }) {
            status.map {StatusView(status: $0)}
        }
    }
}

struct StatusView: View {
    var status: IssueStatus
    
    var body: some View {
        Text(status.name.uppercased())
            .padding(EdgeInsets(top: 3, leading: 15, bottom: 3, trailing: 15))
            .foregroundColor(.white)
            .font(.system(size: 14))
            .background(Color.init(hex: status.color))
            .cornerRadius(20)
    }
}
