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
                MainView().transition(.move(edge: .trailing))
            } else {
                // LoginView(loginMV: LoginModel())
                MainView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
