//
//  ListConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 04.02.2023.
//

import Foundation

protocol ListConfiguratorProtocol: AnyObject {
  func configure(viewController: ListViewController)
}

final class ListConfigurator {
  
}

extension ListConfigurator: ListConfiguratorProtocol {
  func configure(viewController: ListViewController) {
    let presenter = ListPresenter(viewController: viewController)
    let router = ListRouter(viewController: viewController)
    let interactor = ListInteractor()
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
  
}
