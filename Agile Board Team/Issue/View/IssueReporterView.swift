//
//  IssueReporterView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueReporterView: View {
    var reporter: IssueReporter
    
    var body: some View {
        HStack(spacing: 16) {
            if reporter.avatar != nil {
                RemoteImage(stringURL: reporter.avatar!, placeholder: Image(systemName: "person.circle.fill"))
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.lightGreyColor)
            } else {
                Placeholder()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Reporter")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                Text(reporter.name)
                    .font(.system(size: 16))
                
            }
            Spacer()
        }
    }
}

struct IssueReporterView_Previews: PreviewProvider {
    static var previews: some View {
        IssueReporterView(reporter: issueData[0].supporter!)
    }
}

private struct Placeholder: View {
    
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: 25, height: 25, alignment: .center)
            .foregroundColor(.lightGreyColor)
    }
}
