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
        
    private unowned let viewController: BaseViewController
    
    required init(viewController: BaseViewController) {
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
        viewController.navigationController?.setViewControllers([main], animated: true)
    }
    
    
}
