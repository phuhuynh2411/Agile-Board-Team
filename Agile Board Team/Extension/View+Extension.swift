//
//  View+Extension.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/20/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
