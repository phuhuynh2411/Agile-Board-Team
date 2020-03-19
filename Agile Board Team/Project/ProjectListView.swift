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
    
    @State var search: String = ""
    @ObservedObject var viewModel: ProjectListModel
    
    @State private var isShowing = false
    
    @State private var isLoadingMore = false
    
    var isFiltering: Bool {
        viewModel.filter(searchText: search)
        return search.count > 0
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if viewModel.isFailed {
                        ErrorBannerView(message: viewModel.errorMessage, display: $viewModel.isFailed)
                    }
                    SearchView(search: $search)
                    List {
                        ForEach(isFiltering ? viewModel.filteredProjects ?? [] : viewModel.projects) { project in
                            ProjectRowView(project: project).onAppear {
                                self.onAppear(project)
                            }
                        }
                        if self.isLoadingMore {
                            LastRowView(isLoadingMore: $isLoadingMore)
                        }
                        
                    }.pullToRefresh(isShowing: $isShowing) {
                        self.viewModel.reload(animated: false) {
                            self.isShowing = false
                        }
                    }
                }
                if viewModel.isInprogress {
                    InfiniteProgressView()
                }
            }
            .navigationBarTitle("Projects")
        }
    }
    
   
    func onAppear(_ project: Project) {
        guard let lastProject = self.viewModel.projects.last else { return }
        
        if project.id == lastProject.id {
             print("Last row.")
            self.loadMore()
        }
    }
    
    func loadMore() {
        guard !self.isLoadingMore else { return }
    
        self.isLoadingMore = true
       
        self.viewModel.loadMore {
            self.isLoadingMore = false
        }
    }

}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {    
        ProjectListView(viewModel: ProjectListModel())
    }
}

struct SearchView: View {
    @Binding var search: String
    
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search project", text: $search).modifier(ClearButton(text: $search))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.lightGreyColor, lineWidth: 1)
            )
                .padding()
        }
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content
            
            if !text.isEmpty
            {
                Button(action: { self.text = "" })
                {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}

struct LastRowView: View {
    
    @Binding var isLoadingMore: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 70)
                .foregroundColor(.white)
            if self.isLoadingMore {
                InfiniteProgressView().id(UUID().uuidString)
            }
        }
    }
}
