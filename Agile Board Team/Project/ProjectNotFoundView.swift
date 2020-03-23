//
//  ProjectNotFoundView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/23/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct ProjectNotFoundView: View {
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding()
                
                Image(systemName: "xmark")
                .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                .offset(x: -8, y: -8)
                    .foregroundColor(.gray)
            }
            
            Text("No projects found")
                .font(.headline)
                .padding()
            
            Text("Try changing the search criteria")
                .foregroundColor(.secondary)
        }
    }
}

struct ProjectNotFoundView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectNotFoundView()
    }
}
