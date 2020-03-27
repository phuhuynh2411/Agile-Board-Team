//
//  MainView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ProjectListView().environmentObject(ProjectListModel())
                .tabItem {
                    Image(systemName: "folder")
                    Text("Project")
            }
            
            IssueListView().environmentObject(IssueListModel())
                .tabItem {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("Issue")
            }
            
            Text("Notification")
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notification")
            }
            
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
