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
                if viewModel.isFailed {
                    ErrorBannerView(message: viewModel.errorMessage, display: $viewModel.isFailed)
                }
                SearchView(search: $viewModel.search, showCancelButton: $viewModel.showCancelButton)
                    .navigationBarTitle("Projects")
                    .navigationBarHidden(self.viewModel.showCancelButton).animation(.default)
                List {
                    ForEach(viewModel.isFiltering ? viewModel.filteredProjects : viewModel.projects) { (project)  in
                        ProjectRowView(project: project).onAppear {
                            self.onAppear(project)
                        }
                    }
                    
                    if viewModel.isLoadingMore {
                        LastRowView(isLoadingMore: $viewModel.isLoadingMore)
                    }
                    
                }.pullToRefresh(isShowing: $viewModel.isShowing) {
                    self.viewModel.reload(animated: false)
                }.resignKeyboardOnDragGesture()
            }
            .overlay(ProgressBarView(display: $viewModel.isInprogress))
        }
    }
    
   
    func onAppear(_ project: Project) {
        guard viewModel.isLastRow(id: project.id) else { return }
        print("Last row.")
        viewModel.loadMore(animated: true)
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {    
        ProjectListView().environmentObject(ProjectListModel())
    }
}

struct SearchView: View {
    @Binding var search: String
    @Binding var showCancelButton: Bool
    
    var body: some View {
        
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search project", text: $search, onEditingChanged: { (isEditing) in
                    self.showCancelButton = true
                }) {
                    print("on commit")
                }
                
                Button(action: {
                    self.search = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(search == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
           
            if showCancelButton  {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true)
                    self.search = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
            
        }
    .padding()
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


struct ProgressBarView: View {
    @Binding var display: Bool
    
    var body: some View {
        Group {
            if display {
                InfiniteProgressView()
            }
        }
    }
}
