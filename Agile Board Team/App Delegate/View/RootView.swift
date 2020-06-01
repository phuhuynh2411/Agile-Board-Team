//
//  ContentView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/11/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
   @EnvironmentObject var contentMV: RootViewModel
    
    var body: some View {
        ZStack {
            if self.contentMV.managedView == .main {
                MainView().transition(.move(edge: .trailing))
            } else {
                LoginView(loginMV: LoginModel())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(RootViewModel())
    }
}
