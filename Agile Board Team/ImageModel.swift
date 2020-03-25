//
//  ImageModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/18/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ImageModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    var cacheSubscription: AnyCancellable?
    
    init(url: URL?) {
        guard let url = url else { return }
        cacheSubscription = ImageCache
            .image(for: url)
            .replaceError(with: nil)
            .receive(on: RunLoop.main, options: .none)
            .assign(to: \.image, on: self)
    }
}
