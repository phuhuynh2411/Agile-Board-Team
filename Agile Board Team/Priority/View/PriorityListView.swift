//
//  PriorityListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine
import RefreshableList

struct PriorityListView: View {
    @EnvironmentObject var viewModel: PriorityListModel
    @Environment(\.presentationMode) var presentation
     
    var body: some View {
        VStack {
            NavigationBar()
            if viewModel.isFailed {
                ErrorBannerView(message: viewModel.errorMessage, display: $viewModel.isFailed)
            }
            if viewModel.showCancelButton {
                SearchView(search: $viewModel.search, showCancelButton: $viewModel.showCancelButton)
            }
            PriorityNotFoundView()
            RefreshableList(showRefreshView: self.$viewModel.isPulling) {
                ForEach(self.viewModel.isFiltering ? self.viewModel.filtedItems : self.viewModel.items) { priority in
                    self.PriorityButtonView(priority)
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                }
            }
            .onRefreshPerform {
                self.viewModel.reload(byUsing: .pull, animated: true)
            }
            .resignKeyboardOnDragGesture()
            
        }
        .overlay(RefreshView(refreshingPublisher: viewModel.$isRefreshing))
        .onAppear{
            self.viewModel.reload(animated: true, whenEmpty: true)
        }
    }
    
    private func PriorityButtonView(_ priority: IssuePriority) -> some View {
        Button(action: {
            self.viewModel.select(priority) { dismissView in
                if dismissView {
                    self.presentation.wrappedValue.dismiss()
                }
            }
        }) {
            self.PriorityRowView(priority)
        }
    }
    
    private func PriorityRowView(_ priority: IssuePriority) -> some View {
        if let p = self.viewModel.issue?.priority, p.id == priority.id {
            return PriorityRowForListView(priority: priority, isSelected: true)
        } else {
            return PriorityRowForListView(priority: priority)
        }
    }
}

struct PriorityListView_Previews: PreviewProvider {
    @State static var priority: IssuePriority? = issueData[0].priority
    static var previews: some View {
        PriorityListView().environmentObject(PriorityListModel(priorities: priorityData))
    }
}


private struct NavigationBar: View {
    @EnvironmentObject var viewModel: PriorityListModel
    
    var body: some View {
        
        Rectangle()
            .frame(height: 0, alignment: .center)
            .navigationBarTitle("Priority", displayMode: .inline)
            .navigationBarItems(trailing: NavTrailingView())
            .navigationBarHidden(viewModel.showCancelButton)
    }
}

struct PriorityNotFoundView: View {
    @EnvironmentObject var viewModel: PriorityListModel
    
    var body: some View {
        Group {
            if viewModel.emptySearchResult && viewModel.isFiltering {
                NotFoundView(title: "Priority Not Found")
            }
        }
    }
}

private struct NavTrailingView: View {
    @EnvironmentObject var viewModel: PriorityListModel
    
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
