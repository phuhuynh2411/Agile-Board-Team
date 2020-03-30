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
            GeometryReader { proxy in
                VStack {
                    IssueErrorView()
                    IssueSearchView()
                    IssueNotFoundView()
                    NavigationBar()
                    RefreshableScrollView(refreshing: self.$issueListModel.isPulling) {
                        List {
                            ForEach(self.issueListModel.isFiltering ? self.issueListModel.filtedItems : self.issueListModel.items) { (issue)  in
                                NavigationLink(destination: IssueDetailView().environmentObject(IssueDetailModel(issue: issue)) ) {
                                    IssueRowView(issue: issue).onAppear{
                                        self.onAppear(issue)
                                    }
                                }
                            }
                            if self.issueListModel.isLoadingMore {
                                LastRowView(isLoadingMore: self.$issueListModel.isLoadingMore)
                            }
                        }
                        .frame(height: proxy.frame(in: .global).height)
                        
                    }
                    .resignKeyboardOnDragGesture()
                }
                .overlay(
                    CircleProgressView(display: self.$issueListModel.isRefreshing)
                        .frame(width: 30, height: 30, alignment: .center)
                )
            }
        }.onAppear{
            self.issueListModel.reload(animated: true, whenEmpty: true)
        }
    }
    
    func onAppear(_ issue: Issue) {
        guard issueListModel.isLastRow(id: issue.id) else { return }
        issueListModel.loadMore()
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

private struct IssueErrorView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    
    var body: some View {
        Group {
            if self.issueListModel.isFailed {
                ErrorBannerView(message: self.issueListModel.errorMessage, display: self.$issueListModel.isFailed)
            }
        }
    }
}

private struct IssueSearchView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    var body: some View {
        Group {
            if self.issueListModel.showCancelButton {
                SearchView(search: self.$issueListModel.search, showCancelButton: self.$issueListModel.showCancelButton)
            }
        }
    }
}
