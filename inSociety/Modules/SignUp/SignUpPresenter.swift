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
    
    private weak var viewController: SignUpViewControllerProtocol!
    var interactor: SignUpInteractorProtocol!
    var router: SignUpRouterProtocol!
    
    init(viewController: SignUpViewControllerProtocol) {
        self.viewController = viewController
    }
}

extension SignUpPresenter: SignUpPresenterProtocol {
    
    func signUpButtonPressed(email: String?, password: String?, confirmPass: String?) {
        interactor.registrateUser(email: email, password: password,
                                  confirmPass: confirmPass) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.router.toSetupProfileVC(with: user)
            case .failure(let error):
                self.viewController.showAlert(with: "Error", and: error.localizedDescription, completion: {})
            }
        }
    }
}
