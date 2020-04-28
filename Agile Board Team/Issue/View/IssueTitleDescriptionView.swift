//
//  IssueTitleDescriptionView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueTitleDescriptionView: View {
    @EnvironmentObject var modelView: TitleDescriptionModel
    
    @Environment(\.presentationMode) var presentation
    @State private var descriptionSize: CGSize = .zero
    @State private var summarySize: CGSize = .zero
    
        
    var body: some View {
        NavigationView {
            List {
                PlaceholderTextView("Summary", text: $modelView.name,font: UIFont.systemFont(ofSize: 17, weight: .semibold), size: $summarySize)
                    .frame(height: max(self.summarySize.height, 40))
                
                PlaceholderTextView("Description", text: self.$modelView.description, size: $descriptionSize)
                    .frame(height: max(descriptionSize.height, 100))
                
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: self.leadingNavView, trailing: self.trailingNavView)
            .keyboardAwarePadding { _ in }
        }
    }
    
    private var leadingNavView: some View {
        Button(action: {
            self.presentation.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle")
        }
    }
    
    private var trailingNavView: some View {
        Button("Save"){
            
        }
    }
}

struct IssueTitleDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        IssueTitleDescriptionView()
    }
}
