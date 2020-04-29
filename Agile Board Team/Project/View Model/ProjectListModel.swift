//
//  ProjectListModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

class ProjectListModel: BaseListModel<Project, ProjectResponse> {
    override var url: URL { URLSetting.projectURL }
    
    var project: Project?
    
    init(_ project: Project? = nil) {
        self.project = project
        super.init()
    }
}

struct ProjectResponse: ResponseData {
    var currentPage: Int
    var data: [Project]
    var perPage: Int
    var total: Int
}
