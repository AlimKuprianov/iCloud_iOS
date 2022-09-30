//
//  AuthView.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 15.09.2022.
//

import Foundation
import FirebaseAuth
import Combine

final class RegistrationViewModel: ObservableObject {
    
    //MARK: - INPUT
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    //MARK: - OUTPUT
    
    @Published var isValid = false
    @Published var isNeedAlert = false
    @Published var alertMessage = ""
    
    public var emailPlaceholder = "Email"
    public var passwordPlaceholder = "Password"
    public var logInTitle = "Already have an account?"
    public var registrationTitle = "Registration"
    public var signInTitle = "Log in"
    var title = "Registration"
    
    public var user: User
    
    private let auth = Auth.auth()
    
    var buttonOpacity: Double {
        return isValid ? 1.0 : 0.5
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
        private var isEmailEmptyPublisher: AnyPublisher<Bool, Never> {
            $email
                .map({ !$0.isEmpty })
                .eraseToAnyPublisher()
        }
        private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
            $password
                .map { !$0.isEmpty }
                .eraseToAnyPublisher()
        }
        private var isValidPublisher: AnyPublisher<Bool, Never> {
            Publishers.CombineLatest(isEmailEmptyPublisher, isPasswordEmptyPublisher)
                .map { $0 == true && $1 == true }
                .eraseToAnyPublisher()
        }
        
        init(user: User) {
            self.user = user
            isValidPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.isValid, on: self)
                .store(in: &cancellableSet)
        }
    
    public func signUpButtonPressed() {
        
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
                self.alertMessage = "Your account have been created!"
                self.isNeedAlert.toggle()
            }
        
    }
    
    
    public func signInButtonPressed() {

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
                self.alertMessage = "You have Signed In"
                print("\(signInResult?.user.uid)")
            }
        }
}
