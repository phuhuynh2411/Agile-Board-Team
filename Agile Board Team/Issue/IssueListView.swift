//
//  IssueListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueListView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView(search: $issueListModel.search, showCancelButton: $issueListModel.showCancelButton)
                List(issueListModel.issues) { issue in
                    IssueRowView(issue: issue)
                }.pullToRefresh(isShowing: $issueListModel.isShowing) {
                    //self.viewModel.reload(animated: false)
                }.resignKeyboardOnDragGesture()
            }
                
            .navigationBarTitle("Issues")
        }
        
    }
}

struct IssueListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueListView().environmentObject(IssueListModel(issues: issueData))
    }
}
