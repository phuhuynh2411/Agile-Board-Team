//
//  TestList.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct TestList: View {
    var body: some View {
        List(0..<100) { index in
            Text("View \(index)")
        }
    }
}

struct TestList_Previews: PreviewProvider {
    static var previews: some View {
        TestList()
    }
}
