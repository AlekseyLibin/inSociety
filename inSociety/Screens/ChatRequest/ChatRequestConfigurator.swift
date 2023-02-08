//
//  ChatRequestConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol ChatRequestConfiguratorProtocol: AnyObject {
  func configure(viewController: ChatRequestViewController)
}

final class ChatRequestConfigurator {
  
}

extension ChatRequestConfigurator: ChatRequestConfiguratorProtocol {
  func configure(viewController: ChatRequestViewController) {
    let presenter = ChatRequestPresenter(viewController: viewController)
    let router = ChatRequestRouter(viewController: viewController)
    let interactor = ChatRequestInteractor()
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
}
