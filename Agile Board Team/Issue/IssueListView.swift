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
                if issueListModel.isFailed {
                    ErrorBannerView(message: issueListModel.errorMessage, display: $issueListModel.isFailed)
                }
                SearchView(search: $issueListModel.search, showCancelButton: $issueListModel.showCancelButton)
                    .navigationBarTitle("Issues")
                    .navigationBarHidden(self.issueListModel.showCancelButton).animation(.default)
                List {
                    ForEach(issueListModel.isFiltering ? issueListModel.filtedItems : issueListModel.items) { (issue)  in
                        IssueRowView(issue: issue).onAppear{
                            self.onAppear(issue)
                        }
                    }
                    
                    if issueListModel.isLoadingMore {
                        LastRowView(isLoadingMore: $issueListModel.isLoadingMore)
                    }
                    
                }
                .pullToRefresh(isShowing: $issueListModel.isPulling) {
                    self.issueListModel.reload(byUsing: .pull, animated: true)
                }
                .resignKeyboardOnDragGesture()
            }
            .overlay(CircleProgressView(display: $issueListModel.isRefreshing))
            .overlay(IssueNotFoundView())
        }
    }
    
    func onAppear(_ issue: Issue) {
        guard issueListModel.isLastRow(id: issue.id) else { return }
        issueListModel.loadData(byUsing: .loadMore)
    }
}

struct IssueListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueListView().environmentObject(IssueListModel(issues: issueData))
    }
}

struct IssueNotFoundView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    
    var body: some View {
        Group {
            if issueListModel.emptySearchResult && issueListModel.isFiltering {
                NotFoundView(title: "Issue Not Found")
            }
        }
    }
}
