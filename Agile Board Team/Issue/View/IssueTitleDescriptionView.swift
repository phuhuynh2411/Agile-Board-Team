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
    @State private var descriptionSize: CGSize = .zero
    @State private var summarySize: CGSize = .zero
        
    var body: some View {
        NavigationView {
            List {
                PlaceholderTextView("Summary", text: $issue.name,font: UIFont.systemFont(ofSize: 17, weight: .semibold), size: $summarySize)
                    .frame(height: max(self.summarySize.height, 40))
                
                PlaceholderTextView("Description", text: self.$issue.description.bound, size: $descriptionSize)
                    .frame(height: max(descriptionSize.height, 100))
                
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct IssueTitleDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        IssueTitleDescriptionView(issue: issueData[0])
    }
}
