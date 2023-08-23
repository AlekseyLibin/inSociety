//
//  AuthPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth

protocol AuthPresenterInputProtocol: AnyObject {
    func signInWithGoogle(with result: Result<User, Error>)
    func emailButtonPressed()
    func loginButtonPressed()
}

protocol AuthPresenterOutputProtocol: AnyObject {
    
}

final class AuthPresenter {
    
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
        case .success(let currentUser):
            self.interactor.checkIfRegestrationCompleted { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let completedUser):
                    self.router.toMainVC(currentUser: completedUser)
                case .failure:
                  self.viewController.showAlert(with: AuthString.youHaveBeenRegistrated.localized, and: nil) {
                        self.router.toSetupProfileVC(currentUser: currentUser)
                    }
                }
            }
        case .failure(let failure):
          self.viewController.showAlert(with: AuthString.error.localized, and: failure.localizedDescription)
        }
    }
    
    func emailButtonPressed() {
        router.toSignUpVC()
    }
    
    func loginButtonPressed() {
        router.toLoginVC()
    }
}
