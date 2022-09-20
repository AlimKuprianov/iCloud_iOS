//
//  User.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 16.09.2022.
//

import Foundation
import Firebase

class User: ObservableObject {
    
    @Published var userID: String? = {
        let auth = Auth.auth()
        return auth.currentUser?.uid
    }()
    
    var email: String? = {
        let auth = Auth.auth()
        return auth.currentUser?.email
    }()
    
    @Published var token: String?
    
    func getToken(completion: @escaping (Error?) -> Void = { _ in }) {
        
        let auth = Auth.auth()
        auth.currentUser?.getIDToken(completion: { token, error in
            guard error == nil else {
                completion(error)
                return
            }
            self.token = token
            completion(nil)
        })
    }
}
