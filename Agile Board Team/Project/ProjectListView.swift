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
    @ObservedObject var projectMV: ProjectListModelView
    
    @State private var isShowing = false
    
    @State private var isLoadingMore = false
    //@State private var isLastRow = false
    
    var isFiltering: Bool {
        projectMV.filter(searchText: search)
        return search.count > 0
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView(search: $search)
                List {
                    ForEach(isFiltering ? projectMV.filteredProjects ?? [] : projectMV.projects ?? []) { project in
                        ProjectRowView(project: project).onAppear { self.onAppear(project) }
                    }
                    .pullToRefresh(isShowing: $isShowing) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isShowing = false
                        }
                    }
                }
                
                if self.isLoadingMore {
                    LastRowView(isLoadingMore: $isLoadingMore).onAppear { self.loadMoreItems() }
                }
            }
            .navigationBarTitle("Projects")
        }
    }
    
   
    func onAppear(_ project: Project) {
        guard let lastProject = self.projectMV.projects?.last else { return }
        if project.id == lastProject.id {
            self.isLoadingMore = true
        }
    }
    
    func loadMoreItems() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoadingMore = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoadingMore = false
            //self.isLastRow = false
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {    
        ProjectListView(projectMV: ProjectListModelView())
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
                InfiniteProgressView()
            }
        }
    }
}
