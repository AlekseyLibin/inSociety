//
//  SignUpRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth

protocol SignUpRouterProtocol {
    func toSetupProfileVC(with currentUser: User)
}

final class SignUpRouter {
    
    private weak var viewController: BaseViewController!
    
    init(viewController: BaseViewController) {
        self.viewController = viewController
    }
}

extension SignUpRouter: SignUpRouterProtocol {
    
    func toSetupProfileVC(with currentUser: User) {
        let setupProfileVC = SetupProfileViewController(currentUser: currentUser)
        viewController.present(viewController: setupProfileVC)
    }
    
}
