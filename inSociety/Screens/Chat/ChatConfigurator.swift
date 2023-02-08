//
//  ChatConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol ChatConfiguratorProtocol: AnyObject {
  func cofigure(viewController: ChatViewController)
}

final class ChatConfigurator {
  
}

extension ChatConfigurator: ChatConfiguratorProtocol {
  func cofigure(viewController: ChatViewController) {
    let presenter = ChatPresenter(viewController: viewController)
    let router = ChatRouter(viewController: viewController)
    let interactor = ChatInteractor()
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
  
}
