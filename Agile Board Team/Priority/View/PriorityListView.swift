//
//  PriorityListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

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
            List {
                ForEach(viewModel.isFiltering ? viewModel.filtedItems : viewModel.items) { (priority)  in
                    self.PriorityButton(priority: priority)
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
    
     func onAppear(_ priority: IssuePriority) {
         guard viewModel.isLastRow(id: priority.id) else { return }
         viewModel.loadMore()
     }
    
    private func PriorityButton(priority: IssuePriority) -> some View {
        Button(action: {
            self.presentation.wrappedValue.dismiss()
            self.viewModel.selectedPriority = priority
        }) {
            self.PriorityRow(priority: priority).onAppear {
                self.onAppear(priority)
            }
        }
    }
    
    private func PriorityRow(priority: IssuePriority) -> some View {
        if let p = self.viewModel.selectedPriority, p.id == priority.id {
            return PriorityRowView(priority: priority, isSelected: true)
        } else {
            return PriorityRowView(priority: priority)
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
