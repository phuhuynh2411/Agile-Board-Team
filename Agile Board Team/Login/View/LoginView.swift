//
//  LoginView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/11/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @ObservedObject var loginMV: LoginModel
    @State var scrollAttribute = CustomScrollAttribute()
    @State private var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            CustomScrollView(attribute: $scrollAttribute){
                VStack {
                    WelcomeText()
                    PersonImage()
                    UserNameTextField(username: $loginMV.username)
                    PasswordSecureField(password: $loginMV.password)
                    
                    if loginMV.isFailed {
                        ErrorView(message: loginMV.errorMessage)
                            .padding(.bottom, 16)
                    }
                    
                    Button(action: {
                        self.loginMV.login()
                    }) {
                        ButtonContentView(disabled: $loginMV.isValidated)
                    }.disabled(!loginMV.isValidated)
                    
                }
                .padding()
                .keyboardAwarePadding { state in
                    switch state {
                    case .show: self.scrollAttribute.scrollToBottom()
                    case .hide: self.scrollAttribute.scrollToTop()
                    }
                }
            }
            
            self.circularView
        }
        .onReceive(loginMV.$isInprogress) { (value) in
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isAnimating = value
            }
        }
    }
    
    var circularView: some View {
        Group {
            if self.isAnimating {
                InfiniteProgressView()
                    .frame(width: 30, height: 30)
                    .transition(.scale)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginMV: LoginModel())
    }
}

struct WelcomeText: View {
    var body: some View {
        Text("Welcome")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding()
    }
}

struct PersonImage: View {
    var body: some View {
        Image(systemName: "person.fill")
            .resizable()
            .frame(width: 100, height: 100, alignment: .center)
            .foregroundColor(.gray)
            .padding(.bottom, 40)
    }
}

struct UserNameTextField: View {
    
    @Binding var username: String
    
    var body: some View {
        TextField("User name",
                  text: $username)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(Color.lightGreyColor)
            .cornerRadius(5)
            .padding(.bottom, 20)
            .autocapitalization(.none)
    }
}

struct PasswordSecureField: View {
    @Binding var password: String
    
    var body: some View {
        SecureField("Password", text: $password)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(Color.lightGreyColor)
            .cornerRadius(5)
            .padding(.bottom, 20)
    }
}

struct ButtonContentView: View {
    @Binding var disabled: Bool
        
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .frame(width: 150, height: 50)
            .foregroundColor(.white)
            .background(!disabled ? Color.gray : Color.green)
            .cornerRadius(5)
    }
}
