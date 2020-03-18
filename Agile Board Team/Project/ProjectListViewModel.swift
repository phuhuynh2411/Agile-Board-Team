//
//  ProjectListModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

class ProjectListViewModel: BaseViewModel {
    
    @Published var projects: [Project]?
    var filteredProjects: [Project]?
    
    var url: URL { baseURL.appendingPathComponent("api/v1/projects") }
    
    func filter(searchText: String) {
        self.filteredProjects = projects?.filter({ (project) -> Bool in
            project.name.lowercased().contains(searchText.lowercased()) //||
            // project.description.lowercased().contains(searchText.lowercased())
        })
    }
    
    override init() {
        super.init()
        
        self.get()
    }
    
    func get() {
        self.startsRequest()
        
        let request = self.getRequest(url: self.url, addAuthenticationHeader: true)
        
        self.networkRequest = URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .map {
                self.printJSON(data: $0.data)
                return $0.data
            }
            .decode(type: Entry<ResponseData>.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.completed(with: error)
                }
            }) { entry in
                self.completed(with: entry)
        }
    }
    
    func completed(with entry: Entry<ResponseData>) {
        print(entry)
        if entry.meta.success && entry.meta.statusCode == 200 {
            self.toggle(with: true)
            self.projects = entry.data?.data
        } else {
            self.toggle(with: false)
            self.error(with: entry.meta.message)
        }
    }
    
    struct ResponseData: Codable {
        let currentPage: Int
        let data: [Project]
        
        let firstPageUrl: String
        let from: Int
        let lastPage: Int
        let lastPageUrl: String
        let nextPageUrl: String
        let path: String
        let perPage: Int
        let prevPageUrl: String?
        let to: Int
        let total: Int
    }
}
