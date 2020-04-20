//
//  SearchView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @Binding var search: String
    @Binding var showCancelButton: Bool
    var placeholder: String = "Search"
    
    var body: some View {
        
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(self.placeholder, text: $search)
                
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

struct SearchView_Previews: PreviewProvider {
    @State static var search = ""
    @State static var showCancelButton: Bool = false
    
    static var previews: some View {
        SearchView(search: $search, showCancelButton: $showCancelButton)
    }
}
