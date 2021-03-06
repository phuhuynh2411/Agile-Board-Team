//
//  IssueListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import RefreshableList
import Combine

struct IssueListView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    @State private var isRefreshing: Bool = false
    @State private var isPulling: Bool = false
        
    var body: some View {
        
        NavigationView {
            VStack {
                IssueErrorView()
                NavigationBar()
                IssueSearchView()
               
                RefreshableList(showRefreshView: self.$isPulling) {
                    ForEach(self.issueListModel.isFiltering ? self.issueListModel.filtedItems : self.issueListModel.items) { issue  in
                        NavigationLink(destination: IssueDetailView(issue: issue).environmentObject(IssueDetailModel(issue))) {
                            IssueRowView(issue)
                        }
                    }
                    if self.issueListModel.isLoadingMore {
                        LastRowView(isLoadingMore: self.$issueListModel.isLoadingMore)
                    }
                }
                .onRefreshPerform {
                    self.issueListModel.reload(byUsing: .pull)
                }
                .onLastPerform {
                    self.issueListModel.loadMore()
                }
                .resignKeyboardOnDragGesture()
                .overlay(IssueNotFoundView())
                .overlay(RefreshView(refreshingPublisher: self.issueListModel.$isRefreshing))
                .onAppear {
                    self.issueListModel.reload(animated: true, whenEmpty: true)
                }
                .onReceive(self.issueListModel.$isPulling) { (value) in
                    self.isPulling = value
                }
            }
        }
    }
}

//struct IssueListView_Previews: PreviewProvider {
//    static var previews: some View {
//        IssueListView().environmentObject(IssueListModel(issues: issueData))
//    }
//}

struct IssueNotFoundView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    @State var opactiy: Double = 0
    
    var body: some View {
        Group {
            if issueListModel.emptySearchResult && issueListModel.isFiltering {
                NotFoundView(title: "Issue Not Found")
                    .opacity(self.opactiy)
                    .onAppear {
                        withAnimation (.easeInOut(duration: 2)){
                            self.opactiy = 1
                        }
                }
                .onDisappear{
                    self.opactiy = 0
                }
            }
        }
    }
}

private struct NavTrailingView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    
    var body: some View {
   
        HStack (spacing: 25) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
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
    @State private var hide: Bool = false
    
    var body: some View {
        Rectangle()
            .frame(height: 0, alignment: .center)
            .navigationBarTitle("Issues", displayMode: .inline)
            .navigationBarItems(trailing: NavTrailingView() )
            .navigationBarHidden(self.hide)
            .onReceive(self.issueListModel.$showCancelButton) { (value) in
                if !value && self.hide {
                    // Delay 0.5 second before showing the navigation bar
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.hide = value
                    }
                } else {
                    self.hide = value
                }
        }
        
    }
}

private struct IssueErrorView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    
    var body: some View {
        Group {
            if self.issueListModel.isFailed {
                ErrorBannerView(message: self.issueListModel.errorMessage, display: self.$issueListModel.isFailed)
                    .frame(height: 80)
            }
        }
    }
}

private struct IssueSearchView: View {
    @EnvironmentObject var issueListModel: IssueListModel
    var body: some View {
        Group {
            if self.issueListModel.showCancelButton {
                SearchView(
                    search: self.$issueListModel.search,
                    showCancelButton: self.$issueListModel.showCancelButton.animation(.easeInOut(duration: 0.5)),
                    placeholder: "Search issue")
            }
        }
    }
}
