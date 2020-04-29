//
//  ProjectRowView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct ProjectRowView: View {
    @State var project: Project
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            if project.image != nil {
                ProjectIconView(stringURL: project.image!)
            } else {
                PlaceholderView(project: $project)
            }
        
            VStack(alignment: .leading, spacing: 10) {
                Text(project.name)
                    .font(.system(size: 17))
                Text(project.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
        }
        //.padding()
        .frame(height: 60)
    }
}

struct ProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProjectRowView(project: projectData[0])
            ProjectRowView(project: projectData[0], isSelected: true)
        }
    }
}

struct PlaceholderView: View {
    @Binding var project: Project
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: 40, height: 40)
            Text(project.name.prefix(1))
        }
    }
}

struct ProjectIconView: View {
    var stringURL: String
    
    var body: some View {
        RemoteImage(stringURL: stringURL)
            //.resizable()
            .frame(width: 40, height: 40)
            .cornerRadius(7)
            .foregroundColor(.lightGreyColor)
    }
}
