//
//  RemoteImage.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/18/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import SwiftUI

struct RemoteImage : View {
    @ObservedObject var imageModel: ImageModel
    
    init(stringURL: String) {
        if let url = URL(string: stringURL) {
            imageModel = ImageModel(url: url)
            return
        }
        imageModel = ImageModel(url: nil)
    }
    
    var body: some View {
        imageModel
            .image
            .map { Image(uiImage:$0).resizable() }
            ?? Image(systemName: "photo")
                .resizable()
                
    }
    
}
