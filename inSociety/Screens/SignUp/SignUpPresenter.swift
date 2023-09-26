//
//  SignUpPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

protocol SignUpPresenterProtocol: AnyObject {
  func signUpButtonPressed(email: String?, password: String?, confirmPass: String?)
}

final class SignUpPresenter {
  
  private unowned let viewController: SignUpViewControllerProtocol
  var interactor: SignUpInteractorProtocol!
  var router: SignUpRouterProtocol!
  
  init(viewController: SignUpViewControllerProtocol) {
    self.viewController = viewController
  }
}

extension SignUpPresenter: SignUpPresenterProtocol {
  func signUpButtonPressed(email: String?, password: String?, confirmPass: String?) {
    interactor.registrateUser(email: email, password: password, confirmPass: confirmPass) { [weak self] result in
      switch result {
      case .success(let user):
        self?.viewController.generateHapticFeedback(.success)
        self?.router.toSetupProfileVC(with: user)
      case .failure(let error):
        self?.viewController.generateHapticFeedback(.error)
        self?.viewController.showAlert(with: SignUpString.error.localized, and: error.localizedDescription)
      }
    }
  }
}
