//
//  ProjectListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh

struct ProjectListView: View {
    
    @EnvironmentObject var viewModel: ProjectListModel
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationBar()
                if viewModel.isFailed {
                    ErrorBannerView(message: viewModel.errorMessage, display: $viewModel.isFailed)
                }
                if viewModel.showCancelButton {
                    SearchView(search: $viewModel.search, showCancelButton: $viewModel.showCancelButton)
                }
                ProjectNotFoundView()
                List {
                    ForEach(viewModel.isFiltering ? viewModel.filtedItems : viewModel.items) { (project)  in
                        ProjectRowView(project: project).onAppear {
                            self.onAppear(project)
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
        .onAppear{
            self.viewModel.reload(animated: true, whenEmpty: true)
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

private struct NavigationBar: View {
    @EnvironmentObject var viewModel: ProjectListModel
    
    var body: some View {
        
        Rectangle()
            .frame(height: 0, alignment: .center)
            .navigationBarTitle("Projects", displayMode: .large)
            .navigationBarItems(trailing: NavTrailingView() )
            .navigationBarHidden(viewModel.showCancelButton)
    }
}
