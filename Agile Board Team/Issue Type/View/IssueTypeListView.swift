//
//  IssueTypeListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine
import RefreshableList

struct IssueTypeListView: View {
    
    @EnvironmentObject var viewModel: IssueTypeListModel
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
            IssueTypeNotFoundView()
            RefreshableList(showRefreshView: self.$viewModel.isPulling) {
                ForEach(self.viewModel.isFiltering ? self.viewModel.filtedItems : self.viewModel.items) { (issueType)  in
                    self.IssueTypeButton(issueType: issueType)
                    .padding()
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
    
    private func IssueTypeButton(issueType: IssueType) -> some View {
        Button(action: {
            self.viewModel.select(issueType) { (value) in
                if value { self.presentation.wrappedValue.dismiss() }
            }
        }) {
            self.IssueTypeRow(issueType: issueType)
        }
    }
    
    private func IssueTypeRow(issueType: IssueType) -> some View {
        if let p = self.viewModel.issue?.type, p.id == issueType.id {
            return IssueTypeRowForListView(issueType: issueType, isSelected: true)
        } else {
            return IssueTypeRowForListView(issueType: issueType)
        }
    }
}

//struct IssueTypeListView_Previews: PreviewProvider {
//    @State static var issueType: IssueType? = issueData[0].type
//    static var previews: some View {
//        IssueTypeListView().environmentObject(IssueTypeListModel(issueTypes: issueTypeData))
//    }
//}

private struct NavigationBar: View {
    @EnvironmentObject var viewModel: IssueTypeListModel
    
    var body: some View {
        
        Rectangle()
            .frame(height: 0, alignment: .center)
            .navigationBarTitle("Issue Type", displayMode: .inline)
            .navigationBarItems(trailing: NavTrailingView())
            .navigationBarHidden(viewModel.showCancelButton)
    }
}

struct IssueTypeNotFoundView: View {
    @EnvironmentObject var viewModel: IssueTypeListModel
    
    var body: some View {
        Group {
            if viewModel.emptySearchResult && viewModel.isFiltering {
                NotFoundView(title: "Issue type Not Found")
            }
        }
    }
}

private struct NavTrailingView: View {
    @EnvironmentObject var viewModel: IssueTypeListModel
    
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
