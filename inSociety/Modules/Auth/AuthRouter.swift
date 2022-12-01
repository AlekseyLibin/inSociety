//
//  AuthRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth

protocol AuthRouterProtocol: AnyObject {
    func toSignUpVC()
    func toLoginVC()
    func toSetupProfileVC(currentUser: User)
    func toMainVC(currentUser: UserModel)
}

final class AuthRouter {
        
    weak var viewController: AuthViewControllerProtocol!
    
    required init(viewController: AuthViewControllerProtocol) {
        self.viewController = viewController
    }
    
    
    
}


//MARK: AuthRouterProtocol
extension AuthRouter: AuthRouterProtocol {
    
    func toSignUpVC() {
        let signUpVC = SignUpViewController { [weak self] in
            self?.toLoginVC()
        }
        viewController.present(viewController: signUpVC)
    }
    
    func toLoginVC() {
        let loginVC = LoginViewController { [weak self] in
            self?.toSignUpVC()
        }
        viewController.present(viewController: loginVC)
    }
    
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
