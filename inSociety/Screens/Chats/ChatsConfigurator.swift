//
//  ChatsConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 04.02.2023.
//

import Foundation

protocol ChatsConfiguratorProtocol: AnyObject {
  func configure(viewController: ChatsViewController)
}

final class ChatsConfigurator {
  
}

extension ChatsConfigurator: ChatsConfiguratorProtocol {
  func configure(viewController: ChatsViewController) {
    let presenter = ChatsPresenter(viewController: viewController)
    let router = ChatsRouter(viewController: viewController)
    let interactor = ChatsInteractor()
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
  
}
