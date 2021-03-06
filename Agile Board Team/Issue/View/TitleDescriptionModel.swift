//
//  TitleDescriptionModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class TitleDescriptionModel: ObservableObject {
    let issue: Issue
    
    @Published var name: String  = ""
    @Published var description: String = ""
    @Published var isUpdating: Bool = false
    @Published var isFailed: Bool = false
    @Published var errorMessage: String = ""
    
    private var saveStream: AnyCancellable?
    private var disableSaveButtonStream: AnyCancellable?
    @Published var disableSaveButton: Bool = false
    
    init(_ issue: Issue) {
        self.issue = issue
        
        self.name = issue.name
        self.description = issue.description ?? ""
        
        self.disableSaveButtonStream = $name.combineLatest($description).sink(receiveValue: { (name, description) in
            if name != issue.name || description != issue.description {
                self.disableSaveButton = false
            } else {
                self.disableSaveButton = true
            }
        })
    }
    
    func save(callback: @escaping (_ dismissView: Bool)-> Void) {        
        // No changes on issue name and description, just needs to dismiss the view
        guard name != issue.name || description != issue.description else {
            callback(true)
            return
        }
        // Start progress bar
        self.isUpdating = true
        
        let issueAPI = IssueAPI(issue)
        self.saveStream = issueAPI.update(name: self.name, description: self.description)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                self.isUpdating = false
                switch completion {
                case .failure(let error):
                    print(error)
                    self.isFailed = true
                    self.errorMessage = error.localizedDescription
                    callback(false)
                    return
                case .finished: break
                }
                callback(true)
            }, receiveValue: { _ in
                print("The issue has been updated successfully.")
                self.issue.name = self.name
                self.issue.description = self.description
            })
    }
}
