//
//  URLImage.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/18/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct URLImage: View {
    
    @ObservedObject var loader = ImageLoader()
    var placeholder: Image
    
    init(stringURL: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        self.loader.load(stringURL)
    }
    
    var body: some View {
        if let image = loader.downloadedImage {
            return Image(uiImage: image)
        } else {
            return placeholder
        }
    }
}

struct URLImage_Previews: PreviewProvider {
    static let url = "https://i.picsum.photos/id/862/100/100.jpg"
    
    static var previews: some View {
        URLImage(stringURL: url)
    }
}
