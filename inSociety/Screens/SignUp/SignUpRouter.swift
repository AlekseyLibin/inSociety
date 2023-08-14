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
    init(viewController: BaseViewController) {
        self.viewController = viewController
    }
  
  private unowned var viewController: BaseViewController
}

extension SignUpRouter: SignUpRouterProtocol {
    
    func toSetupProfileVC(with currentUser: User) {
      let setupProfileVC = SetupProfileViewController(currentUser: currentUser, target: .create)
        viewController.present(viewController: setupProfileVC)
    }
    
}
