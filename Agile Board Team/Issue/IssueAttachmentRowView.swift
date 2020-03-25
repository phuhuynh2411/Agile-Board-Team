//
//  IssueAttachmentLabelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueAttachmentRowView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Attachments")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text("2")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
    
            
        }
    }
}

struct IssueAttachmentRowView_Previews: PreviewProvider {
    static var previews: some View {
        IssueAttachmentRowView()
    }
}
