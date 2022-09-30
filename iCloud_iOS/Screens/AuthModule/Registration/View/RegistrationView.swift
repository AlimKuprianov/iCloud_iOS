//
//  AuthView.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 15.09.2022.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var authViewModel: RegistrationViewModel
    @StateObject var user = User()
    var body: some View {
        
            ZStack {
                
                VStack {
                    
                    Spacer()
                    
                    LottieView(fileName: "SignForm",
                               repeating: true)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .padding(.bottom)
                    
                    
                    HStack(spacing: 10) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color.gray)
                        TextField(authViewModel.emailPlaceholder, text: $authViewModel.email)
                            .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        
                    }
                    
                    Divider()
                        .padding(10)
                    
                    HStack(spacing: 10) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color.gray)
                        SecureField(authViewModel.passwordPlaceholder, text: $authViewModel.password)
                    }
                    Spacer(minLength: 10)
                    
                    VStack(spacing: 0) {
                        
                        Button {
                            authViewModel.signUpButtonPressed()
                            
                        } label: {
                            Text(authViewModel.registrationTitle)
                                .frame(width: 311, height: 50)
                                .background(Color(red: 0/255, green: 115/255, blue: 239/255))
                                .cornerRadius(30)
                                .foregroundColor(.white).opacity(authViewModel.buttonOpacity)

                                .padding(15)
                        }
                        .disabled(!authViewModel.isValid)

            
                        Button {
                            authViewModel.signInButtonPressed()
                            print("Button")
                            
                        } label: {
                            Text(authViewModel.signInTitle)
                                .frame(width: 311, height: 50)
                                .background(Color.gray)
                                .cornerRadius(30)
                                .foregroundColor(.white).opacity(authViewModel.buttonOpacity)
                                .padding(5)
                        }
                        .disabled(!authViewModel.isValid)
                    }
                    Spacer()
                }
            }
            .navigationTitle(authViewModel.title)
        
        .padding()
        .alert(isPresented: $authViewModel.isNeedAlert, content: {
            Alert(title: Text(authViewModel.alertMessage),
                  dismissButton: .default(Text("OK")))
        })
    }
}

