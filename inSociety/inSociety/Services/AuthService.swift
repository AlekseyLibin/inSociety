//
//  AuthService.swift
//  inSociety
//
//  Created by Aleksey Libin on 19.10.2022.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    func login(email: String?,
               password: String?,
               completion: @escaping (Result<User, Error>) -> Void) {
        
        
        let error = Validator.checkLoginValidation(email: email, password: password)
        if let error = error {
            completion(.failure(error))
            return
        }
        
        auth.signIn(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    func googleLogin(clientID: String?, presentingVC: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingVC) { [unowned self] user, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard
                let auth = user?.authentication,
                let idToken = auth.idToken
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: auth.accessToken)
            
            self.auth.signIn(with: credential) { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                switch result {
                case .none:
                    completion(.failure(AuthError.couldNotAuthWithGoogle))
                case .some(let success):
                    completion(.success(success.user))
                }
            }
        }
    }
    
    func register(email: String?,
                  password: String?,
                  confirmPassword: String?,
                  completion: @escaping (Result<User, Error>) -> Void) {
        
        let error = Validator.checkRegisterValidation(email: email,
                                                  password: password,
                                                  confirmPassword: confirmPassword)
        if let error = error {
            completion(.failure(error))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    
}
