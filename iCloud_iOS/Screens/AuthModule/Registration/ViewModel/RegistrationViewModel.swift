//
//  AuthView.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 15.09.2022.
//

import Foundation
import FirebaseAuth

final class RegistrationViewModel: ObservableObject {
    
    //MARK: - INPUT
    
    var email: String = ""
    var password: String = ""
    
    //MARK: - OUTPUT
    
    @Published var isValid = false
    @Published var isNeedAlert = false
    @Published var alertMessage = ""
    
    public var emailPlaceholder = "Почта"
    public var passwordPlaceholder = "Пароль"
    public var logInTitle = "Уже есть аккаунт?"
    public var registrationTitle = "Регистрация"
    public var signInTitle = "Войти"
    var title = "Регистрация"
    
    public var user: User
    
    private let auth = Auth.auth()
    
    var buttonOpacity: Double {
        return isValid ? 1.0 : 0.5
    }
    
    private var isEmailValid: Bool {
        return !email.isEmpty
    }
    
    private var isPasswordValid: Bool {
        return !password.isEmpty
    }
    
    init(user: User) {
        self.user = user
    }
    
    
    
    public func signUpButtonPressed() {
        
        if isEmailValid && isPasswordValid {
            isValid = true
            auth.createUser(withEmail: email, password: password) { authResult, error in
                
                guard error == nil else  {
                    print("error")
                    self.alertMessage = error?.localizedDescription ?? "Unknown Error"
                    self.isNeedAlert.toggle()
                    return
                }
                
                guard authResult != nil else {
                    print("authResult error")
                    self.alertMessage = error?.localizedDescription ?? "Unknown Error"
                    self.isNeedAlert.toggle()
                    return
                }
                self.alertMessage = "Ваш аккаунт успешно создан"
                self.isNeedAlert.toggle()
                print("Ваш аккаунт успешно создан")
            }
        }
    }
    
    
    public func signInButtonPressed() {
        if isEmailValid && isPasswordValid {
            isValid = true

            auth.signIn(withEmail: email, password: password) { signInResult, error in
                guard error == nil else {
                    self.alertMessage = error?.localizedDescription ?? "Unknown Error"
                    self.isNeedAlert.toggle()
                    return
                }

                guard signInResult != nil else {
                    self.alertMessage = error?.localizedDescription ?? "UnknownError"
                    self.isNeedAlert.toggle()
                    return
                }
                self.user.userID = signInResult?.user.uid
                self.user.email = signInResult?.user.email
                self.user.getToken()
                self.isNeedAlert.toggle()
                self.alertMessage = "Вы успешно зашли в свой аккаунт"
                print("\(signInResult?.user.uid)")
            }
        }
        
    }
}
