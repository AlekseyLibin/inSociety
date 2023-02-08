//
//  ChatRequestRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol ChatRequestRouterProtocol {
  
}

final class ChatRequestRouter {
  init(viewController: ChatRequestViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ChatRequestViewControllerProtocol
}

extension ChatRequestRouter: ChatRequestRouterProtocol {
  
}
