//
//  LoginPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth

protocol LoginPresenterProtocol {
  func loginWithGoogle(with options: Result<User, Error>)
  func loginWithEmail(email: String?, password: String?)
}

final class LoginPresenter {
  
  private unowned let viewController: LoginViewControllerProtocol
  var interactor: LoginInteractorProtocol!
  var router: LoginRouterProtocol!
  
  init(viewController: LoginViewControllerProtocol) {
    self.viewController = viewController
  }
}

extension LoginPresenter: LoginPresenterProtocol {
  func loginWithEmail(email: String?, password: String?) {
    AuthService.shared.login(email: email, password: password) { [weak self] result in
      switch result {
      case .success(let currentUserModel):
        self?.interactor.checkIfRegestrationCompleted { result in
          switch result {
          case .success(let currentCompletedUserModel):
            self?.viewController.generateHapticFeedback(.success)
            self?.router.toMainVC(currentUser: currentCompletedUserModel)
          case .failure:
            self?.viewController.generateHapticFeedback(.success)
            self?.router.toSetupProfileVC(currentUser: currentUserModel)
          }
        }
      case .failure(let error):
        self?.viewController.generateHapticFeedback(.error)
        self?.viewController.showAlert(with: LoginString.error.localized, and: error.localizedDescription)
      }
    }
  }
  
  func loginWithGoogle(with options: Result<User, Error>) {
    switch options {
    case .success(let currentUserModel):
      self.interactor.checkIfRegestrationCompleted { [weak self] result in
        switch result {
        case .success(let currentCompletedUserModel):
          self?.viewController.stopLoadingAnimation()
          self?.viewController.generateHapticFeedback(.success)
          self?.router.toMainVC(currentUser: currentCompletedUserModel)
        case .failure:
          self?.viewController.stopLoadingAnimation()
          self?.viewController.generateHapticFeedback(.success)
          self?.router.toSetupProfileVC(currentUser: currentUserModel)
        }
      }
    case .failure(let error):
      print(error.localizedDescription)
      viewController.stopLoadingAnimation()
    }
  }
}
