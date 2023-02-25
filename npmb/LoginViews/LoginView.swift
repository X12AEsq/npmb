//
//  LoginView.swift
//  ah2404
//
//  Created by Morris Albers on 2/20/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var isShowingRegistrationView = false
    
    @EnvironmentObject var commonVM: CommonViewModel

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                VStack {
                    Text("Login")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Enter userid and password")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.vertical, 60)
                VStack(spacing: 20) {
                    TextField("Enter Email", text: $email)
                        .modifier(CustomTextField())
                        .disableAutocorrection(true)
                    SecureField("Enter Password", text: $password)
                        .modifier(CustomTextField())
                        

                }
                .padding(.horizontal)
                .padding(.top, 60)
                Spacer()
                VStack(spacing: 20) {
                    Button {
                        Task {
                            await commonVM.signIn(withEmail: email, password: password)
                        }
                    } label: {
                        Text("sign in")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 55)
                            .background(.red.opacity(0.3), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                    .buttonStyle(CustomButton())
                    HStack {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Button {
                            isShowingRegistrationView = true
                        } label: {
                            Text("sign up")
                                .font(.subheadline.bold())
                                .foregroundColor(.red.opacity(0.7))
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
