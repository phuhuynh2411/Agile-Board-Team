//
//  IssueStatusListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import RefreshableList

struct IssueStatusListView: View {
    @EnvironmentObject var viewModel: IssueStatusListModel
    @Environment(\.presentationMode) var presentation
     
    var body: some View {
        VStack {
            NavigationBar()
            if viewModel.isFailed {
                ErrorBannerView(message: viewModel.errorMessage, display: $viewModel.isFailed)
                    .frame(height: 80)
            }
            if viewModel.showCancelButton {
                SearchView(search: $viewModel.search, showCancelButton: $viewModel.showCancelButton)
            }
            IssueStatusNotFoundView()
            RefreshableList(showRefreshView: self.$viewModel.isPulling) {
                ForEach(self.viewModel.isFiltering ? self.viewModel.filtedItems : self.viewModel.items) { (issueStatus)  in
                    self.IssueStatusButton(issueStatus)
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                }
                if self.viewModel.isLoadingMore {
                    LastRowView(isLoadingMore: self.$viewModel.isLoadingMore)
                }
            }
            .onRefreshPerform {
                self.viewModel.reload(byUsing: .pull, animated: true)
            }
            .resignKeyboardOnDragGesture()
            
        }
        .overlay(RefreshView(refreshingPublisher: viewModel.$isRefreshing))
        .onAppear {
            self.viewModel.reload(animated: true, whenEmpty: true)
        }
    }
    
    private func IssueStatusButton(_ issueStatus: IssueStatus) -> some View {
        Button(action: {
            self.viewModel.select(issueStatus) { (value) in
                if value { self.presentation.wrappedValue.dismiss() }
            }
        }) {
            self.IssueStatusRow(issueStatus: issueStatus)
        }
    }
    
    private func IssueStatusRow(issueStatus: IssueStatus) -> some View {
        if let p = self.viewModel.issue?.status, p.id == issueStatus.id {
            return IssueStatusRowForListView(issueStatus: issueStatus, isSelected: true)
        } else {
            return IssueStatusRowForListView(issueStatus: issueStatus)
        }
    }
}

struct IssueStatusListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueStatusListView()
    }
}

private struct NavigationBar: View {
    @EnvironmentObject var viewModel: IssueStatusListModel
    
    var body: some View {
        
        Rectangle()
            .frame(height: 0, alignment: .center)
            .navigationBarTitle("Issue Status", displayMode: .inline)
            .navigationBarItems(trailing: NavTrailingView())
            .navigationBarHidden(viewModel.showCancelButton)
    }
}

private struct IssueStatusNotFoundView: View {
    @EnvironmentObject var viewModel: IssueStatusListModel
    
    var body: some View {
        Group {
            if viewModel.emptySearchResult && viewModel.isFiltering {
                NotFoundView(title: "Issue status Not Found")
            }
        }
    }
}

private struct NavTrailingView: View {
    @EnvironmentObject var viewModel: IssueStatusListModel
    
    var body: some View {
   
        HStack (spacing: 25) {
            Button(action: {
                withAnimation(.easeInOut(duration: 1)) {
                    self.viewModel.showCancelButton = true
                }
            }) {
                Image(systemName: "magnifyingglass")
            }
        }
    }
}
