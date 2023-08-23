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
            guard let self = self else { return }
            
            switch result {
            case .success(let currentUserModel):
                self.interactor.checkIfRegestrationCompleted { result in
                    switch result {
                    case .success(let currentCompletedUserModel):
                        self.router.toMainVC(currentUser: currentCompletedUserModel)
                    case .failure:
                        self.router.toSetupProfileVC(currentUser: currentUserModel)
                    }
                }
            case .failure(let error):
              self.viewController.showAlert(with: LoginString.error.localized, and: error.localizedDescription)
            }
        }
    }
    
    func loginWithGoogle(with options: Result<User, Error>) {
        switch options {
        case .success(let currentUserModel):
            
            self.interactor.checkIfRegestrationCompleted { result in
                switch result {
                case .success(let currentCompletedUserModel):
                    self.router.toMainVC(currentUser: currentCompletedUserModel)
                case .failure:
                  self.viewController.showAlert(with: LoginString.youHaveBeenRegistrated.localized, and: nil) {
                        self.router.toSetupProfileVC(currentUser: currentUserModel)
                    }
                }
            }
        case .failure(let error):
          self.viewController.showAlert(with: LoginString.error.localized, and: error.localizedDescription)
        }
    }
    
}
