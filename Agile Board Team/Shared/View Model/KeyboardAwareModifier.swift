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
    typealias Action = (_ state: KeyboardState) -> Void
    var action: Action
    
    public init(_ action: @escaping Action) {
        self.action = action
    }

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
            .onReceive(keyboardHeightPublisher) { value in
                self.keyboardHeight = value
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if value == 0 {
                        self.action(.hide)
                    } else {
                        self.action(.show)
                    }
                }
        }
    }
    
    public enum KeyboardState {
        case show
        case hide
    }
}

extension View {
    func keyboardAwarePadding(_ action: @escaping KeyboardAwareModifier.Action) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier(action))
    }
}
