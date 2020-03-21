//
//  ProjectListModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

class ProjectListModel: NetworkModel<ProjectListModel.ResponseData>, URLSetting {
    
    @Published var projects: [Project] = []
    @Published var filteredProjects: [Project] = []
    @Published var search: String = ""
    @Published var isLoadingMore = false
    
    var page = 0
    var numberOfItems: Int {
        self.entry?.data?.perPage ?? 15
    }
    
    typealias Completion = ()->Void
    var completion: Completion?
    var searchStream: AnyCancellable?
    var remoteSearchStream: AnyCancellable?
    
    var isFiltering: Bool {
        return self.search.count > 0
    }
    
    override init() {
        super.init()
        _ = self.objectWillChange.append(super.objectWillChange)
        
        self.reload(animated: true)
        
        self.searchStream = $search
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { (searchText) in
                self.filteredProjects = self.projects.filter {
                     $0.name.lowercased().contains(searchText.lowercased())
                }
            })
        
        self.remoteSearchStream = $search
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .setFailureType(to: Error.self)
            .map {
                self.isLoadingMore = true
                return $0
            }
            .flatMap { searchText in
                self.download(page: 1, numberOfItems: self.numberOfItems, keyword: searchText)
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.completed(with: error)
                    self.isLoadingMore = false
                }
            }) { entry in
                print(entry)
                let foundProjects = entry.data?.data.filter { lhs in
                    !self.projects.contains { rhs in
                        lhs.id == rhs.id
                    }
                }
                self.filteredProjects.append(contentsOf: foundProjects ?? [])
                self.isLoadingMore = false
        }
    }
    
    func download(page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> AnyPublisher<Entry<ResponseData>, Error> {
        var urlComponent = URLComponents(url: self.projectURL, resolvingAgainstBaseURL: true)!
        urlComponent.queryItems = []
        if let page = page {
            urlComponent.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        if let numberOfItems = numberOfItems {
            urlComponent.queryItems?.append(URLQueryItem(name: "limit", value: "\(numberOfItems)") )
        }
        if let keyword = keyword {
            urlComponent.queryItems?.append(URLQueryItem(name: "keyword", value: "\(keyword)") )
        }
    
        let request = self.get(url: urlComponent.url!, authen: true)
        return send(request: request)
    }
    
    func get() {
        self.cancelable = self.download(page: self.page + 1, numberOfItems: self.numberOfItems)
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
        if animated { self.displayProgressbar(true)}
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
    
    override func completed(with entry: Entry<ResponseData>) {
        super.completed(with: entry)
        
        if entry.meta.success && entry.meta.statusCode == 200 {
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
