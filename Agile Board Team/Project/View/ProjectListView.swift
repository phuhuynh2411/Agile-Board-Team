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
    var navDisplayMode: NavigationBarItem.TitleDisplayMode = .large
    var useDefaultNavView: Bool = true
    
    init(navDisplayMode: NavigationBarItem.TitleDisplayMode = .large, useDefaultNavView: Bool = true) {
        UITableView.appearance().separatorStyle = .none
        self.navDisplayMode = navDisplayMode
        self.useDefaultNavView = useDefaultNavView
    }
    
    var body: some View {
        Group {
            if self.useDefaultNavView {
                NavigationView {
                    self.content
                }
            } else {
                self.content
            }
        }
    }
    
    private var content: some View {
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
                     ProjectButtonView(project: project)
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
         
         .navigationBarTitle("Projects", displayMode: self.navDisplayMode)
         .navigationBarItems(trailing: NavTrailingView() )
         .navigationBarHidden(viewModel.showCancelButton)
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
                withAnimation(.easeInOut(duration: 0.5)) {
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


struct ProjectButtonView: View {
    @ObservedObject var project: Project
    @EnvironmentObject var viewModel: ProjectListModel
     @Environment(\.presentationMode) var presentation
    
    var body: some View {
        Button(action: {
            self.viewModel.select(self.project) { dismissView in
                if dismissView {
                    self.presentation.wrappedValue.dismiss()
                }
            }
        }) {
            self.projectRowView
        }
    }
    
    private var projectRowView: some View {
        guard let p = viewModel.project, p.id == project.id else {
            return AnyView(ProjectRowView(project: project, isSelected: false))
        }
        return AnyView(ProjectRowView(project: project, isSelected: true))
    }
}

