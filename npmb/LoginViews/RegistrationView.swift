//
//  RegistrationView.swift
//  ah2404
//
//  Created by Morris Albers on 2/20/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var commonVM: CommonViewModel
    
    var body: some View {
        ZStack  {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("Sign up Now")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Please fill the details and create account")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.vertical, 60)
                
                VStack(spacing: 20) {
                    
                    TextField("Enter Name", text: $name)
                        .modifier(CustomTextField())
                    
                    TextField("Enter Email", text: $email)
//                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .modifier(CustomTextField())
                    
                    SecureField("Enter Password", text: $password)
                        .modifier(CustomTextField())
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button {
                        Task {
                            await commonVM.createUser(withEmail: email, password: password)
                        }
                    } label: {
                        Text("create account")

                    }
                    .buttonStyle(CustomButton())
                    
                    HStack {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("sign in")
                                .font(.subheadline.bold())
                                .foregroundColor(.red.opacity(0.7))
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
