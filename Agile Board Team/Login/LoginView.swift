//
//  LoginView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/11/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var loginMV: LoginModelView
    
    var body: some View {
        VStack {
            WelcomeText()
            PersonImage()
            UserNameTextField(username: $loginMV.username)
            PasswordSecureField(password: $loginMV.password)
            
            if loginMV.loginDidFail {
                ErrorText(errorMessage: $loginMV.errorMessage)
            }
            
            Button(action: { self.loginMV.login() }) {
                ButtonContentView()
            }
        }
        .padding()
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginMV: LoginModelView())
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
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .frame(width: 200, height: 60)
            .foregroundColor(.white)
            .cornerRadius(15)
            .background(Color.green)
    }
}

struct ErrorText: View {
    @Binding var errorMessage: String
    var body: some View {
        Text(errorMessage)
            .foregroundColor(.red)
            .font(.system(size: 17))
            .padding(.bottom, 20)
    }
}
