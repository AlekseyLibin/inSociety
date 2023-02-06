//
//  ProfileConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol ProfileConfiguratorProtocol: AnyObject {
  func configure(viewController: ProfileViewController)
}

final class ProfileConfigurator {
  
}

extension ProfileConfigurator: ProfileConfiguratorProtocol {
  func configure(viewController: ProfileViewController) {
    let presenter = ProfilePresenter(viewController: viewController)
    let router = ProfileRouter(viewController: viewController)
    let interactor = ProfileInteractor()
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
  
}
