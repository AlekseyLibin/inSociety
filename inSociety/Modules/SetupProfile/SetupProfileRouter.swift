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
    
    private weak var viewController: BaseViewController!
    
    init(viewController: BaseViewController!) {
        self.viewController = viewController
    }
}

extension SetupProfileRouter: SetupProfileRouterProtocol {
    
    func toMainVC(currentUser: UserModel) {
        
        let main = MainTabBarController(currentUser: currentUser)
        viewController.navigationController?.setViewControllers([main], animated: true)
    }
    
    
}
