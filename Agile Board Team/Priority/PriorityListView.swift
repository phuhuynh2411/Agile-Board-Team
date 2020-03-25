//
//  PriorityListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct PriorityListView: View {
    @EnvironmentObject var viewModel: PriorityListModel
     
     init() {
         UITableView.appearance().separatorStyle = .none
     }
     
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
            List {
                ForEach(viewModel.isFiltering ? viewModel.filtedItems : viewModel.items) { (priority)  in
                    PriorityRowView(priority: priority).onAppear {
                        self.onAppear(priority)
                    }
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
        .overlay(CircleProgressView(display: $viewModel.isRefreshing))
    }
    
     func onAppear(_ priority: IssuePriority) {
         guard viewModel.isLastRow(id: priority.id) else { return }
         viewModel.loadMore()
     }
}

struct PriorityListView_Previews: PreviewProvider {
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
