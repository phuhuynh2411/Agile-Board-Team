//
//  KeyboardAwareModifier.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/8/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            //.offset(y: -self.keyboardHeight)
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 ; print(self.keyboardHeight )}
    }
}

extension View {
    func keyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}
