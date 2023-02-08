//
//  AuthConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import UIKit

protocol AuthConfiguratorProtocol: AnyObject {
    func configure(with viewController: AuthViewController)
}

final class AuthConfigurator: AuthConfiguratorProtocol {
    func configure(with viewController: AuthViewController) {
        let presenter = AuthPresenter(viewController: viewController)
        let router = AuthRouter(viewController: viewController)
        let interactor = AuthInteractor()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
}
