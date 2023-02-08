//
//  ChatRequestPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol ChatRequestPresenterProtocol: AnyObject {
  
}

final class ChatRequestPresenter {
  init(viewController: ChatRequestViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ChatRequestViewControllerProtocol
  var interactor: ChatRequestInteractorProtocol!
  var router: ChatRequestRouterProtocol!
}

extension ChatRequestPresenter: ChatRequestPresenterProtocol {
  
}
