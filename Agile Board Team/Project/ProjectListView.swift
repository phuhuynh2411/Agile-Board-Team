//
//  ProjectListView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct ProjectListView: View {
    var body: some View {
        NavigationView {
            List(projectData) { project in
                ProjectRowView(project: project)
            }
            .navigationBarTitle("Projects")
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
