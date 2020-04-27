//
//  IssueTitleDescriptionView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueTitleDescriptionView: View {
    @ObservedObject var issue: Issue
        
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Summary", text: self.$issue.name)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                
                TextField("Description", text: self.$issue.description.bound)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct IssueTitleDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        IssueTitleDescriptionView(issue: issueData[0])
    }
}
