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
            IssueIDView(issue: issue)
            
            TitleButtonView(issue: issue)
            
            StatusButtonView(status: issue.status)

            DescriptionButtonView(issue: issue)

            IssueTypeButtonView(issue: self.issue)

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
}

//struct IssueDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        IssueDetailView(o)//.environmentObject(IssueDetailModel(issue: issueData[0]))
//    }
//}

struct IssueIDView: View {
    @ObservedObject var issue: Issue
    
    var body: some View {
        HStack {
            self.iconView
            Text(issue.issueNumber)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Spacer()
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

struct IssueTypeButtonView: View {
    @ObservedObject var issue: Issue
    
    var body: some View {
        NavigationLink(destination: IssueTypeListView()
            .environmentObject(IssueTypeListModel(issue: self.issue))) {
                self.issue.type.map { IssueTypeRowView(issueType: $0) } // Unwrap optional issue type
        }
    }
}

struct TitleButtonView: View {
    @ObservedObject var issue: Issue
    @State private var showDetail: Bool = false
    
    var body: some View {
        Button(action: {
            self.showDetail = true
        }) {
            TitleView(name: self.issue.name)
        }.sheet(isPresented: $showDetail) {
            IssueTitleDescriptionView(issue: issueData[0])
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
    @ObservedObject var issue: Issue
    @State private var showDetail: Bool = false
    
    var body: some View {
        Button(action: {
            self.showDetail = true
        }) {
            DescriptionView(description: issue.description)
        }.sheet(isPresented: $showDetail) {
            IssueTitleDescriptionView(issue: self.issue)
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
