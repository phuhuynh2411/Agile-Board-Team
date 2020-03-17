//
//  ProjectListModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

class ProjectListModelView: ObservableObject {
    @Published var projects: [Project]? = projectData
    var filteredProjects: [Project]?
    //@Published var search: String = ""
    
    func filter(searchText: String) {
        self.filteredProjects = projects?.filter({ (project) -> Bool in
            project.name.lowercased().contains(searchText.lowercased()) ||
            project.description.lowercased().contains(searchText.lowercased())
        })
    }
}
