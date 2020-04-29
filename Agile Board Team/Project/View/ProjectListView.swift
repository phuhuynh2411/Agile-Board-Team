//
//  ProjectListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import RefreshableList

struct ProjectListView: View {
    @EnvironmentObject var viewModel: ProjectListModel
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if self.viewModel.showCancelButton {
                    SearchView(search: self.$viewModel.search, showCancelButton: self.$viewModel.showCancelButton)
                }
                if self.viewModel.isFailed {
                    ErrorBannerView(message: self.viewModel.errorMessage, display: self.$viewModel.isFailed)
                    frame(height: 80)
                }
                
                ProjectNotFoundView()
                RefreshableList(showRefreshView: $viewModel.isPulling) {
                    ForEach(self.viewModel.isFiltering ? self.viewModel.filtedItems : self.viewModel.items) { project in
                        ProjectRowView(project: project)
                    }
                    if self.viewModel.isLoadingMore {
                        LastRowView(isLoadingMore: self.$viewModel.isLoadingMore)
                    }
                }
                .onRefreshPerform {
                    self.viewModel.reload(byUsing: .pull, animated: true)
                }
                .onLastPerform {
                    self.viewModel.loadMore()
                }
                .resignKeyboardOnDragGesture()
                
                Spacer()
            }
            .overlay(RefreshView(refreshingPublisher: viewModel.$isRefreshing))
            .onAppear {
                self.viewModel.reload(animated: true, whenEmpty: true)
            }
            
            .navigationBarTitle("Projects", displayMode: .large)
            .navigationBarItems(trailing: NavTrailingView() )
            .navigationBarHidden(viewModel.showCancelButton)
        }
    }
    
   
    func onAppear(_ project: Project) {
        guard viewModel.isLastRow(id: project.id) else { return }
        viewModel.loadMore()
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {    
        ProjectListView().environmentObject(ProjectListModel())
    }
}

struct ProjectNotFoundView: View {
    @EnvironmentObject var viewModel: ProjectListModel
    
    var body: some View {
        Group {
            if viewModel.emptySearchResult && viewModel.isFiltering {
                NotFoundView(title: "Project Not Found")
            }
        }
    }
}


private struct NavTrailingView: View {
    @EnvironmentObject var viewModel: ProjectListModel
    
    var body: some View {
   
        HStack (spacing: 25) {
            Button(action: {
                withAnimation(.easeInOut(duration: 1)) {
                    self.viewModel.showCancelButton = true
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
