//
//  AuthPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth
import AuthenticationServices
import CryptoKit

protocol AuthPresenterInputProtocol: AnyObject {
  func signInWithGoogle(with result: Result<User, Error>)
    func didCompleteWithAuthorization(_ authorization: ASAuthorization)
    func appleButtonPressed()
  func emailButtonPressed()
  func loginButtonPressed()
}

final class AuthPresenter {
  
  private var currentNonce: String?
  private unowned let viewController: AuthViewControllerProtocol
  var interactor: AuthInteractorProtocol!
  var router: AuthRouterProtocol!
  
  init(viewController: AuthViewControllerProtocol) {
    self.viewController = viewController
  }
  
}

extension AuthPresenter: AuthPresenterInputProtocol {
  func signInWithGoogle(with result: Result<User, Error>) {
    switch result {
    case .success(let googleUser):
      self.interactor.checkIfRegestrationCompleted { [weak self] result in
        switch result {
        case .success(let completedUser):
          self?.viewController.stopLoadingAnimation()
          self?.router.toMainVC(currentUser: completedUser)
        case .failure:
          self?.viewController.stopLoadingAnimation()
          self?.viewController.generateHapticFeedback(.success)
          self?.router.toSetupProfileVC(currentUser: googleUser, appleIdUserName: nil)
        }
      }
    case .failure(let failure):
      print(failure.localizedDescription)
      viewController.stopLoadingAnimation()
    }
  }
  
  func emailButtonPressed() {
    viewController.stopLoadingAnimation()
    router.toSignUpVC()
  }
  
  func loginButtonPressed() {
    viewController.stopLoadingAnimation()
    router.toLoginVC()
  }
  
  func appleButtonPressed() {
    let nonce = randomNonceString()
    currentNonce = nonce
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = viewController 
    controller.performRequests()
  }
  
  /// Handle Apple ID authorization
  func didCompleteWithAuthorization(_ authorization: ASAuthorization) {
    viewController.playLoadingAnimation()
    guard let currentNonce = currentNonce,
          let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let token = credential.identityToken,
          let tokenString = String(data: token, encoding: .utf8) else { return }
    let oAuthCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: currentNonce)
    
    let userIdentifier = credential.user
    if let fullName = credential.fullName, fullName.description != "" {
      let name = "\(fullName.givenName ?? "") \(fullName.familyName ?? "")"
      UserDefaults.standard.set(name, forKey: userIdentifier)
    }
    
    Auth.auth().signIn(with: oAuthCredential) { [weak self] result, error in
      if let error = error {
        self?.viewController.generateHapticFeedback(.error)
        self?.viewController.showAlert(with: AuthString.error.localized, and: error.localizedDescription)
        self?.viewController.stopLoadingAnimation()
      } else {
        guard let user = result?.user else { return }
        self?.interactor.checkIfRegestrationCompleted(completion: { result in
          switch result {
          case .success(let completedUser):
            self?.viewController.stopLoadingAnimation()
            self?.router.toMainVC(currentUser: completedUser)
          case .failure:
            self?.viewController.stopLoadingAnimation()
            self?.viewController.generateHapticFeedback(.success)
            let appleIdUserName = UserDefaults.standard.string(forKey: userIdentifier)
            print(appleIdUserName)
            self?.router.toSetupProfileVC(currentUser: user, appleIdUserName: appleIdUserName)
          }
        })
      }
    }
  }
  
}


// MARK: - AppleAuth methods
private extension AuthPresenter {
  func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
      fatalError(
        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
      )
    }
    
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    
    let nonce = randomBytes.map { byte in
      // Pick a random character from the set, wrapping around if needed.
      charset[Int(byte) % charset.count]
    }
    
    return String(nonce)
  }
  
  func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
}
