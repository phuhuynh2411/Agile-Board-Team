//
//  IssueRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueRowView: View {
    var issue: Issue
    
    init(issue: Issue){
        self.issue = issue
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "doc")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
            VStack(alignment: .leading, spacing: 16) {
                Text(self.issue.name)
                    .font(.headline)
                HStack {
                    Text("FT-0001")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.yellow)
                    Text("TODO")
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                        .background(Color.blue)
                        .cornerRadius(7.0)
                    Spacer()
                    Text("Due today")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
            }
        }
        .frame(height: 70, alignment: .leading)
        //.padding()
    }
}

struct IssueRowView_Previews: PreviewProvider {
    static var previews: some View {
        IssueRowView(issue: issueData[0])
    }
}
