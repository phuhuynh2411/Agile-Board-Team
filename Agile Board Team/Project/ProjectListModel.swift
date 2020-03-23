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
    @Published var showCancelButton = false
    @Published var isShowing = false

    var page = 0
    var numberOfItems: Int {
        self.entry?.data?.perPage ?? 15
    }
    
    var remoteSearchStream: AnyCancellable?
    
    var isFiltering: Bool {
        return self.search.count > 0
    }
    var searchPage = 0
    var keyword: String?
    @Published var emptySearchResult = false
    
    override init() {
        super.init()
        _ = self.objectWillChange.append(super.objectWillChange)
        
        self.reload(animated: true)
        
        self.remoteSearchStream = $search
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .setFailureType(to: Error.self)
            .map {
                return $0
            }
            .flatMap { searchText in
               self.search(page: 1, numberOfItems: self.numberOfItems, keyword: searchText)
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
                let foundProjects = entry.data?.data ?? []
                
                self.filteredProjects = foundProjects
                self.isLoadingMore = false
                self.searchPage = 1
                self.emptySearchResult = foundProjects.count == 0
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
    
    func search(page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> AnyPublisher<Entry<ResponseData>, Error> {
        self.emptySearchResult = false
        guard let searchText = keyword, searchText.count > 0 else {
            return Empty(outputType: Entry<ResponseData>.self, failureType: Error.self).eraseToAnyPublisher()
        }
        
        self.isLoadingMore = true
        self.keyword = keyword
        return self.download(page: 1, numberOfItems: self.numberOfItems, keyword: searchText)
    }
    
    func get(callback: @escaping (Entry<ResponseData>?, Error?)->Void) {
        self.cancelable = self.download(
            page: isFiltering ? self.searchPage + 1 : self.page + 1,
            numberOfItems: self.numberOfItems,
            keyword: isFiltering ? self.keyword : nil
        )
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    callback(nil, error)
                }
            }) { entry in
                callback(entry, nil)
        }
    }
    
    func reload(animated: Bool = false) {
        self.resetPageNumber()
        if animated { self.displayProgressbar(true)}
        self.get { (entry, error) in
            if let error = error {
                self.completed(with: error)
            } else {
                self.completed(with: entry!)
            }
            self.isShowing = false
        }
    }
    
    private func resetPageNumber() {
        if isFiltering {
            self.searchPage = 0
            self.filteredProjects.removeAll()
        } else {
            self.page = 0
            self.projects.removeAll()
        }
    }
    
    func loadMore(animated: Bool = true) {
        if animated { self.isLoadingMore = true }
        self.get { (entry, error) in
            if let error = error {
                self.completed(with: error)
            } else {
                self.completed(with: entry!)
                self.isLoadingMore = false
            }
        }
    }
    
    override func completed(with entry: Entry<ResponseData>) {
        super.completed(with: entry)
        
        if entry.meta.success && entry.meta.statusCode == 200 {
            guard let downloadedProjects = entry.data?.data, downloadedProjects.count > 0 else { return }
            if isFiltering {
                self.filteredProjects.append(contentsOf: downloadedProjects)
                self.searchPage += 1
            } else {
                self.projects.append(contentsOf: downloadedProjects)
                self.page += 1
            }
        } else {
            self.toggle(with: false)
            self.error(with: entry.meta.message)
        }
    }
    
    func isLastRow(id: String) -> Bool {
        guard let lastProject = isFiltering ? self.filteredProjects.last : self.projects.last else { return false }
        return lastProject.id == id
    }
    
    struct ResponseData: Codable {
        let currentPage: Int
        let data: [Project]
        let perPage: Int
        let total: Int
    }
    
    enum RequestError: Error {
        case emptySearch
    }
}
