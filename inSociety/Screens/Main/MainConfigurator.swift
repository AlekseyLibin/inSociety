//
//  MainConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.02.2023.
//

protocol MainConfiguratorProtocol: AnyObject {
  func configure(viewController: MainTabBarController)
}

final class MainConfigurator {
  
}

extension MainConfigurator: MainConfiguratorProtocol {
  
  func configure(viewController: MainTabBarController) {
    let presenter = MainPresenter(viewController: viewController)
    let router = MainRouter(viewController: viewController)
    let interactor = MainInteractor()
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
  
  
}
