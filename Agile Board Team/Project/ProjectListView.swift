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
    var projects: [Project]
    @State var search: String = ""
    var filteredProjects: [Project]?
    
    @State private var isShowing = false
    
    var isFiltering: Bool {
        return search.count > 0
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView(search: $search)
                List(isFiltering ? [] : projects) { project in
                    ProjectRowView(project: project)
                }
                .pullToRefresh(isShowing: $isShowing) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isShowing = false
                    }
                }
            }
            .navigationBarTitle("Projects")
        }
    }
    
    func test() {
        
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(projects: projectData)
    }
}

struct SearchView: View {
    @Binding var search: String
    
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search project", text: $search)
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
