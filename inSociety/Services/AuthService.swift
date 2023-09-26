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
import AuthenticationServices
import CryptoKit

final class AuthService {
  
  static let shared = AuthService()
  private init() { }
  
  private let auth = Auth.auth()
  private var currentNonce: String?
  
  private var clientId: String? {
    return FirebaseApp.app()?.options.clientID
  }
  
  /// Registrates a new account with email and password
  func register(by email: String?, and password: String?, confirm confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
    
    guard
      let email = email,
      let password = password,
      let confirmPassword = confirmPassword
    else {
      completion(.failure(AuthError.fieldsAreNotFilled))
      return
    }
    
    let error = Validator.checkRegisterValidation(email: email,
                                                  password: password,
                                                  confirmPassword: confirmPassword)
    if let error = error {
      completion(.failure(error))
      return
    }
    
    auth.createUser(withEmail: email, password: password) { result, error in
      guard let result = result else {
        completion(.failure(error!))
        return
      }
      
      completion(.success(result.user))
    }
  }
  
  /// Logs into existing account
  func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
    guard let email = email,
          let password = password
    else { completion(.failure(AuthError.fieldsAreNotFilled)); return }

    if let error = Validator.checkLoginValidation(email: email, password: password) {
      completion(.failure(error))
      return
    }
    
    auth.signIn(withEmail: email, password: password) { result, error in
      guard let result = result else { completion(.failure(error!)); return }
      
      completion(.success(result.user))
    }
  }
  
  /// Enters to the system with provided Google account
  func enter(_ presentingVC: BaseViewController, withGoogle completion: @escaping (Result<User, Error>) -> Void) {
    guard let clientID = self.clientId else { return }
    
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] result, error in
      guard let self = self else { return }
      presentingVC.playLoadingAnimation()
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard
        let user = result?.user,
        let idToken = user.idToken?.tokenString
      else { return }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                     accessToken: user.accessToken.tokenString)
      
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
  
}
