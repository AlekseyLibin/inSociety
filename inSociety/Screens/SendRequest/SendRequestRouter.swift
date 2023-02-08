//
//  SendRequestRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol SendRequestRouterProtocol: AnyObject {
  
}

final class SendRequestRouter {
  init(viewController: SendRequestViewControllerProtocol) {
    self.viewController = viewController
  }
  private unowned let viewController: SendRequestViewControllerProtocol
}

extension SendRequestRouter: SendRequestRouterProtocol {
  
}
