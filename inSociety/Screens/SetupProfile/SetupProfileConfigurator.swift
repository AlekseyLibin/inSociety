//
//  SetupProfileConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

protocol SetupProfileConfiguratorProtocol: AnyObject {
  func configure(viewController: SetupProfileViewController)
}

final class SetupProfileConfigurator {
  
}

extension SetupProfileConfigurator: SetupProfileConfiguratorProtocol {
  func configure(viewController: SetupProfileViewController) {
    let presenter = SetupProfilePresenter(viewController: viewController)
    let router = SetupProfileRouter(viewController: viewController)
    let interactor = SetupProfileInteractor()
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
  
}
