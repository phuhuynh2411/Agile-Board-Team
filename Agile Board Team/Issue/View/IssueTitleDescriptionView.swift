//
//  IssueTitleDescriptionView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct IssueTitleDescriptionView: View {
    @EnvironmentObject var viewModel: TitleDescriptionModel
    
    @Environment(\.presentationMode) var presentation
    @State private var descriptionSize: CGSize = .zero
    @State private var summarySize: CGSize = .zero
    
    @State private var showActionSheet: Bool = false
    
        
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isFailed {
                    ErrorBannerView(message: viewModel.errorMessage, display: $viewModel.isFailed)
                        .frame(height: 80)
                }
                
                List {
                    PlaceholderTextView("Summary", text: $viewModel.name,font: UIFont.systemFont(ofSize: 17, weight: .semibold), size: $summarySize)
                        .frame(height: max(self.summarySize.height, 40))
                    
                    PlaceholderTextView("Description", text: self.$viewModel.description, size: $descriptionSize)
                        .frame(height: max(descriptionSize.height, 100))
                    
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading: self.leadingNavView, trailing: self.trailingNavView)
                .keyboardAwarePadding { _ in }
                .overlay(RefreshView(refreshingPublisher: viewModel.$isUpdating))
                .actionSheet(isPresented: self.$showActionSheet) {
                    ActionSheet(
                        title: Text("Discard change"),
                        message: Text("All changes you made will be lost. Are you sure to do that?"),
                        buttons: [.cancel(Text("Cancel")),
                                  .destructive(Text("Delete changes"),
                                               action: {self.presentation.wrappedValue.dismiss()})
                    ])
                }
            }
            
        }
    }
    
    private var leadingNavView: some View {
        // Close button
        Button(action: {
            self.cancelButtonTapped()
        }) {
            Image(systemName: "xmark.circle")
        }
    }
    
    private var trailingNavView: some View {
        // Save button
        Button("Save"){
            self.saveButtonTapped()
        }.disabled(self.viewModel.disableSaveButton)
    }
    
    private func saveButtonTapped() {
        self.viewModel.save { (dismissView) in
            if dismissView {
                self.presentation.wrappedValue.dismiss()
            }
        }
    }
    
    private func cancelButtonTapped() {
        guard !self.viewModel.disableSaveButton else {
            self.presentation.wrappedValue.dismiss()
            return
        }
        
        self.showActionSheet = true
    }
}

struct IssueTitleDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        IssueTitleDescriptionView()
    }
}
