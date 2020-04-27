//
//  ErrorView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    var message: String = ""
    
    var body: some View {
        HStack {
            Text(self.message)
            .foregroundColor(.red)
            Spacer()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Morbi leo risus, porta ac consectetur ac, vestibulum at eros.")
    }
}
