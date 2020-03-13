//
//  ContentView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/11/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
   @EnvironmentObject var contentMV: ViewRouter
    
    var body: some View {
        ZStack {
            if self.contentMV.managedView == .main {
                withAnimation(.easeIn){
                    MainView()
                }
                
            } else {
                LoginView(loginMV: LoginModelView())
            }
        }
        
    }
}

enum ManagedView {
    case login
    case main
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
