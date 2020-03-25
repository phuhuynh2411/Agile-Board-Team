//
//  ProjectRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueProjectRowView: View {
   var project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Project")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            HStack {
                if project.image != nil {
                    RemoteImage(stringURL: project.image!)
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.lightGreyColor)
                } else {
                    Image(systemName: "photo")
                    .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                }
                Text(project.name)
                    .font(.system(size: 16))
                Spacer()
            }
        }
    }
}

struct IssueProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        IssueProjectRowView(project: issueData[0].project)
    }
}
