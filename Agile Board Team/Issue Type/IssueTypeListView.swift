//
//  IssueTypeListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

struct IssueTypeListView: View {
    
    @EnvironmentObject var viewModel: IssueTypeListModel
    @Environment(\.presentationMode) var presentation
    @Binding var issueType: IssueType?
     
    var body: some View {
        VStack {
            NavigationBar()
            if viewModel.isFailed {
                ErrorBannerView(message: viewModel.errorMessage, display: $viewModel.isFailed)
            }
            if viewModel.showCancelButton {
                SearchView(search: $viewModel.search, showCancelButton: $viewModel.showCancelButton)
            }
            IssueTypeNotFoundView()
            List {
                ForEach(viewModel.isFiltering ? viewModel.filtedItems : viewModel.items) { (issueType)  in
                    self.IssueTypeButton(issueType: issueType)
                }
                
                if viewModel.isLoadingMore {
                    LastRowView(isLoadingMore: $viewModel.isLoadingMore)
                }
                
            }
            .pullToRefresh(isShowing: $viewModel.isPulling) {
                self.viewModel.reload(byUsing: .pull, animated: true)
            }
            .resignKeyboardOnDragGesture()
            
        }
        .overlay(
            CircleProgressView(display: $viewModel.isRefreshing)
            .frame(width: 30, height: 30, alignment: .center)
        )
        .onAppear{
            self.viewModel.reload(animated: true, whenEmpty: true)
        }
    }
    
     func onAppear(_ issueType: IssueType) {
         guard viewModel.isLastRow(id: issueType.id) else { return }
         viewModel.loadMore()
     }
    
    private func IssueTypeButton(issueType: IssueType) -> some View {
        Button(action: {
            self.presentation.wrappedValue.dismiss()
            self.issueType = issueType
        }) {
            self.IssueTypeRow(issueType: issueType).onAppear {
                self.onAppear(issueType)
            }
        }
    }
    
    private func IssueTypeRow(issueType: IssueType) -> some View {
        if let p = self.issueType, p.id == issueType.id {
            return IssueTypeRowForListView(issueType: issueType, isSelected: true)
        } else {
            return IssueTypeRowForListView(issueType: issueType)
        }
    }
}

struct IssueTypeListView_Previews: PreviewProvider {
    @State static var issueType: IssueType? = issueData[0].type
    static var previews: some View {
        IssueTypeListView(issueType: $issueType).environmentObject(IssueTypeListModel(issueTypes: issueTypeData))
    }
}

private struct NavigationBar: View {
    @EnvironmentObject var viewModel: IssueTypeListModel
    
    var body: some View {
        
        Rectangle()
            .frame(height: 0, alignment: .center)
            .navigationBarTitle("Priority", displayMode: .inline)
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
