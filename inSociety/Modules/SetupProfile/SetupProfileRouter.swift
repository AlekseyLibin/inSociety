//
//  SetupProfileRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

protocol SetupProfileRouterProtocol {
    func toMainVC(currentUser: UserModel)
}

final class SetupProfileRouter {
    
    private weak var viewController: SetupProfileViewControllerProtocol!
    
    init(viewController: SetupProfileViewControllerProtocol!) {
        self.viewController = viewController
    }
}

extension SetupProfileRouter: SetupProfileRouterProtocol {
    
    func toMainVC(currentUser: UserModel) {
        
        //MARK: - Fail - navigationController in nil
//        viewController.navigationController?.setViewControllers([main], animated: true)
        
        let main = MainTabBarController(currentUser: currentUser)
        main.modalPresentationStyle = .fullScreen
        viewController.present(viewController: main)
    }
    
    
}
