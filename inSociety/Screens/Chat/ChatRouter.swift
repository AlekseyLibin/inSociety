//
//  ChatRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol ChatRouterProtocol: AnyObject {
  
}

final class ChatRouter {
  init(viewController: ChatViewControllerProtocol) {
    self.viewController = viewController
  }
  private unowned let viewController: ChatViewControllerProtocol
}

extension ChatRouter: ChatRouterProtocol {
  
}
