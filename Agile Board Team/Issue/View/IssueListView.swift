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
                if issueListModel.showCancelButton {
                    SearchView(search: $issueListModel.search, showCancelButton: $issueListModel.showCancelButton)
                }
                IssueNotFoundView()
                NavigationBar()
                RefreshableScrollView(refreshing: self.$issueListModel.isPulling) {
                    //List {
                        ForEach(issueListModel.isFiltering ? issueListModel.filtedItems : issueListModel.items) { (issue)  in
                            NavigationLink(destination: IssueDetailView().environmentObject(IssueDetailModel(issue: issue)) ) {
                                IssueRowView(issue: issue).onAppear{
                                    self.onAppear(issue)
                                }
                            }
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        
                        if issueListModel.isLoadingMore {
                            LastRowView(isLoadingMore: $issueListModel.isLoadingMore)
                        }
                    //}
                    
                }
                .resignKeyboardOnDragGesture()
            }
            .overlay(
                CircleProgressView(display: $issueListModel.isRefreshing)
                .frame(width: 30, height: 30, alignment: .center)
            )
        }.onAppear{
            self.issueListModel.reload(animated: true, whenEmpty: true)
        }
    }
    
    func onAppear(_ issue: Issue) {
        guard issueListModel.isLastRow(id: issue.id) else { return }
        //issueListModel.loadMore()
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

private struct NavTrailingView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    
    var body: some View {
   
        HStack (spacing: 25) {
            Button(action: {
                withAnimation(.easeInOut(duration: 1)) {
                    self.issueListModel.showCancelButton = true
                }
            }) {
                Image(systemName: "magnifyingglass")
            }
            
            Button(action: {
                
            }) {
                Image(systemName: "plus")
            }
        }
    }
}

private struct NavigationBar: View {
    @EnvironmentObject var issueListModel: IssueListModel
    
    var body: some View {
        
        Rectangle()
            .frame(height: 0, alignment: .center)
            .navigationBarTitle("Issues", displayMode: .inline)
            .navigationBarItems(trailing: NavTrailingView() )
            .navigationBarHidden(issueListModel.showCancelButton)
    }
}
