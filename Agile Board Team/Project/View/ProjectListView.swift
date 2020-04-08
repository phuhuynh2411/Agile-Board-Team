//
//  ProjectListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
//import SwiftUIRefresh

struct ProjectListView: View {
    
    @EnvironmentObject var viewModel: ProjectListModel
    //@Binding var editedProject: Project?
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    NavigationBar()
                    if self.viewModel.isFailed {
                        ErrorBannerView(message: self.viewModel.errorMessage, display: self.$viewModel.isFailed)
                    }
                    if self.viewModel.showCancelButton {
                        SearchView(search: self.$viewModel.search, showCancelButton: self.$viewModel.showCancelButton)
                    }
                    ProjectNotFoundView()
                    //RefreshableScrollView(refreshing: self.$viewModel.isPulling) {
                    ScrollView {
                        List {
                            ForEach(self.viewModel.isFiltering ? self.viewModel.filtedItems : self.viewModel.items) { (project)  in
                                ProjectRowView(project: project).onAppear {
                                    self.onAppear(project)
                                }
                            }
                            
                            if self.viewModel.isLoadingMore {
                                LastRowView(isLoadingMore: self.$viewModel.isLoadingMore)
                            }
                            
                        }
                        //.frame(height: proxy.frame(in: .named("myStack")).height)
                    }
                    .frame(height: 500)
                    .resignKeyboardOnDragGesture()
                    
                }
                .coordinateSpace(name: "myStack")
                .overlay(
                    CircleProgressView(display: self.$viewModel.isRefreshing)
                        .frame(width: 30, height: 30, alignment: .center)
                )
            }
        }
        .onAppear{
            //self.viewModel.reload(animated: true, whenEmpty: true)
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
