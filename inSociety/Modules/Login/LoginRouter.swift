//
//  LoginRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth

protocol loginRouterProtocol {
    func toSetupProfileVC(currentUser: User)
    func toMainVC(currentUser: UserModel)
}

final class LoginRouter {
    
    private weak var viewController: LoginViewControllerProtocol!
    
    init(viewController: LoginViewControllerProtocol) {
        self.viewController = viewController
    }
    
}


extension LoginRouter: loginRouterProtocol {
    
    func toSetupProfileVC(currentUser: User) {
        let setupProfileVC = SetupProfileViewController(currentUser: currentUser)
        viewController.present(viewController: setupProfileVC)
    }
    
    func toMainVC(currentUser: UserModel) {
        let main = MainTabBarController(currentUser: currentUser)
        main.modalPresentationStyle = .fullScreen
//        viewController.navigationController?.setViewControllers([main], animated: true)
        //MARK: - navigationController is nil
        viewController.present(viewController: main)
    }
    
}
