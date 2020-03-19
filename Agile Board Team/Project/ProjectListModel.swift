//
//  ProjectListModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

class ProjectListModel: BaseViewModel {
    
    @Published var projects: [Project] = []
    var filteredProjects: [Project]?
    
    var url: URL { baseURL.appendingPathComponent("api/v1/projects") }
    
    var page = 0
    var entry: Entry<ResponseData>?
    var numberOfItems: Int {
        self.entry?.data?.perPage ?? 15
    }
    
    typealias Completion = ()->Void
    var completion: Completion?
    
    override init() {
        super.init()
        
        self.reload(animated: true)
    }
    
    func filter(searchText: String) {
        self.filteredProjects = projects.filter({ (project) -> Bool in
            project.name.lowercased().contains(searchText.lowercased()) //||
            // project.description.lowercased().contains(searchText.lowercased())
        })
    }
    
    func download() -> AnyPublisher<Entry<ResponseData>, Error> {
        var urlComponent = URLComponents(url: self.url, resolvingAgainstBaseURL: true)!
        urlComponent.queryItems = [
            URLQueryItem(name: "page", value: "\(self.page + 1)"),
            URLQueryItem(name: "limit", value: "\(self.numberOfItems)")
        ]
        
        let request = self.getRequest(url: urlComponent.url!, addAuthenticationHeader: true)
        
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .map {
                self.printJSON(data: $0.data)
                return $0.data
        }
        .decode(type: Entry<ResponseData>.self, decoder: jsonDecoder)
        .mapError { error in error }
        .eraseToAnyPublisher()
    }
    
    func get() {
        self.networkRequest = self.download()
            .receive(on: RunLoop.main)
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
    
    func reload(animated: Bool = false, completion: Completion? = nil) {
        self.reset()
        
        self.completion = completion
        if animated { self.displaysProgressBar() }
        self.get()
    }
    
    func reset() {
        self.page = 0
        self.projects.removeAll()
        self.entry = nil
        self.completion = nil
    }
    
    func loadMore(completion: Completion? = nil) {
        self.completion = completion
        self.get()
    }
    
    override func completed(with error: Error) {
        super.completed(with: error)
        self.completion?()
    }
    
    func completed(with entry: Entry<ResponseData>) {
        print(entry)
        self.entry = entry
        
        if entry.meta.success && entry.meta.statusCode == 200 {
            self.toggle(with: true)
            guard let downloadedProjects = entry.data?.data else { return }
            self.projects.append(contentsOf: downloadedProjects)
            self.page += 1
        } else {
            self.toggle(with: false)
            self.error(with: entry.meta.message)
        }
        
        self.completion?()
    }
    
    struct ResponseData: Codable {
        let currentPage: Int
        let data: [Project]
        let perPage: Int
        let total: Int
    }
}
