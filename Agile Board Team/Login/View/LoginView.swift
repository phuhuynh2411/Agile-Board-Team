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
    
    var body: some View {
        ZStack {
            VStack {
                WelcomeText()
                PersonImage()
                UserNameTextField(username: $loginMV.username)
                PasswordSecureField(password: $loginMV.password)
                
                if loginMV.isFailed {
                    ErrorView(errorMessage: loginMV.errorMessage)
                }
                
                Button(action: { self.loginMV.signIn() }) {
                    ButtonContentView(disabled: $loginMV.isValidated)
                }.disabled(!loginMV.isValidated)
            }
            .padding()
            
            if loginMV.isInprogress {
                InfiniteProgressView()
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
        Text("Wellcome")
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
            .padding(.bottom, 75)
    }
}

struct UserNameTextField: View {
    
    @Binding var username: String
    
    var body: some View {
        TextField("User name", text: $username)
            .padding()
            .background(Color.lightGreyColor)
            .cornerRadius(5)
            .padding(.bottom, 20)
    }
}

struct PasswordSecureField: View {
    @Binding var password: String
    
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
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
            .frame(width: 200, height: 60)
            .foregroundColor(.white)
            .cornerRadius(15)
            .background(!disabled ? Color.gray : Color.green)
    }
}
