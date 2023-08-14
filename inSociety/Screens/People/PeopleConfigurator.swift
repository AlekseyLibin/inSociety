//
//  PeopleConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.02.2023.
//

import Foundation

protocol PeopleConfiguratorProtocol: AnyObject {
  func configure(viewController: PeopleViewControllerProtocol)
}

final class PeopleConfigurator {
    
}

extension PeopleConfigurator: PeopleConfiguratorProtocol {
  func configure(viewController: PeopleViewControllerProtocol) {
    let presenter = PeoplePresenter(viewController: viewController)
    let router = PeopleRouter(viewController: viewController)
    let interactor = PeopleInteractor()
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
  
}
