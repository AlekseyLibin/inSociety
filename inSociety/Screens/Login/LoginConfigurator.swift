//
//  LoginConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import UIKit

protocol LoginConfiguratorProtocol {
    func configure(with viewController: LoginViewController)
}

final class LoginConfigurator {
    
}

extension LoginConfigurator: LoginConfiguratorProtocol {
    func configure(with viewController: LoginViewController) {
        let presenter = LoginPresenter(viewController: viewController)
        let router = LoginRouter(viewController: viewController)
        let interactor = LoginInteractor()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
}
