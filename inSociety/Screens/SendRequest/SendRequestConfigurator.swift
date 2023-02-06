//
//  SendRequestConfigurator.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol SendRequestConfiguratorProtocol: AnyObject {
  func configure(viewController: SendRequestViewController)
}

final class SendRequestConfigurator {
  
}

extension SendRequestConfigurator: SendRequestConfiguratorProtocol {
  func configure(viewController: SendRequestViewController) {
    let presenter = SendRequestPresenter(viewController: viewController)
    let router = SendRequestRouter(viewController: viewController)
    let interactor = SendRequestInteractor()
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
}
