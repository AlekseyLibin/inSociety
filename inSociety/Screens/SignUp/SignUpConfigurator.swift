//
//  SignUpConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

protocol SignUpConfiguratorProtocol: AnyObject {
    func configure(viewController: SignUpViewController)
}

final class SignUpConfigurator {
    
}

extension SignUpConfigurator: SignUpConfiguratorProtocol {
    func configure(viewController: SignUpViewController) {
        let presenter = SignUpPresenter(viewController: viewController)
        let router = SignUpRouter(viewController: viewController)
        let interactor = SignUpInteractor()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
    
}
