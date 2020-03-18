//
//  ImageLoader.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/18/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import Combine

class ImageLoader: ObservableObject {
    
    @Published var downloadedImage: UIImage?
    var downloadRequest: AnyCancellable?
    
    func load(_ stringURL: String) {
        guard let url = URL(string: stringURL) else { return }
        
        self.downloadRequest = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { data in
                print("Got remote image")
                self.downloadedImage = UIImage(data: data)
            })
    }
}
