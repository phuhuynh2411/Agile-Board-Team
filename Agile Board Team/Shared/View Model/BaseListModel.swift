
//
//  BaseModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class BaseListModel <T:Identifiable, ResponseType:ResponseData>: ObservableObject, NetworkModel {
    
    @Published var isFailed = false
    @Published var search: String = ""
    @Published var showCancelButton = false
    @Published var emptySearchResult = false
    
    @Published var errorMessage = ""
    @Published var isRefreshing = false
    @Published var isPulling = false
    
    @Published var isLoadingMore = false
    
    var page = 0
    var numberOfItems = 15
    
    var remoteSearchStream: AnyCancellable?
    
    var isFiltering: Bool {
        self.search.count > 0
    }
    var searchPage = 0
    var keyword: String?
    
    @Published var items: [T] = []
    @Published var filtedItems: [T] = []
    var entry: Entry<ResponseType>?
    
    var cancelableRequest: Cancellable?
    var url: URL { URLSetting.baseURL }
    
    init() {
        
        self.remoteSearchStream = $search
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .setFailureType(to: Error.self)
            .map { $0 }
            .flatMap { searchText in
                self.search(page: 1, numberOfItems: self.numberOfItems, keyword: searchText)
                .catch { error in
                    Just(Entry.placeholder(message: error.localizedDescription))
                                        .setFailureType(to: Error.self)
                }
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isFailed = true
                    self.errorMessage = error.localizedDescription
                    self.isLoadingMore = false
                }
            }) { entry in
                print(entry)
                let foundItems = entry.data?.data ?? []
                
                self.filtedItems = foundItems as! [T]
                self.isLoadingMore = false
                self.searchPage = 1
                self.emptySearchResult = foundItems.count == 0
        }
    }
    
    init(items: [T]) {
        self.items = items
    }
    
    private func get()->AnyPublisher<Entry<ResponseType>, Error> {
        return self.getData(from: self.url,
                                     page: isFiltering ? self.searchPage + 1 : self.page + 1,
                                     numberOfItems: self.numberOfItems,
                                     keyword: isFiltering ? self.keyword : nil
        )
    }
    
    private func search(page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> AnyPublisher<Entry<ResponseType>, Error> {
        self.emptySearchResult = false
        guard let searchText = keyword, searchText.count > 0 else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        
        self.isLoadingMore = true
        self.keyword = keyword
        return self.getData(from: self.url, page: 1, numberOfItems: self.numberOfItems, keyword: searchText)
    }
    
    private func resetPageNumber() {
        if isFiltering {
            self.searchPage = 0
            self.filtedItems.removeAll()
        } else {
            self.page = 0
            self.items.removeAll()
        }
    }
    
    func reload(byUsing progressType: ProgressType = .refresh, animated: Bool = false, whenEmpty: Bool = false) {
        if whenEmpty, self.items.count > 0 { return }
        //self.resetPageNumber()
        self.loadData(byUsing: progressType, animated: animated)
    }
    
    func loadData(byUsing progressType: ProgressType, animated: Bool = true) {
        self.set(progressType, status: animated)
        
        self.cancelableRequest = self.get()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                self.set(progressType, status: false)
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error)
                    self.isFailed = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { (entry) in
                self.set(progressType, status: false)
                if progressType == .refresh || progressType == .pull {
                    self.resetPageNumber()
                }
                self.completed(with: entry)
            })
    }
    
    func loadMore(){
        guard !isRefreshing else { return }
        self.loadData(byUsing: .loadMore)
    }
    
    private func completed(with entry: Entry<ResponseType>) {
        if entry.meta.success && entry.meta.statusCode == 200 {
            guard let downloadedItems = entry.data?.data as? [T], downloadedItems.count > 0 else { return }
            if isFiltering {
                self.filtedItems.append(contentsOf: downloadedItems)
                self.searchPage += 1
            } else {
                self.items.append(contentsOf: downloadedItems)
                self.page += 1
            }
        } else {
            self.isFailed = true
            self.errorMessage = entry.meta.message
        }
    }
    
    func isLastRow(id: String) -> Bool {
        guard let lastItem = isFiltering ? self.filtedItems.last : self.items.last else { return false }
        let numberOfItems = isFiltering ? self.filtedItems.count : self.items.count
        return lastItem.id as! String == id && numberOfItems >= self.numberOfItems
    }
    
    enum ProgressType {
        case refresh
        case pull
        case loadMore
    }
    
    func set(_ type: ProgressType, status: Bool){
        switch type {
        case .loadMore:
            self.isLoadingMore = status
            break
        case .pull:
            self.isPulling = status
            break
        case .refresh:
            self.isRefreshing = status
            break
        }
    }
    
}
