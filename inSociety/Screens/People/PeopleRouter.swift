//
//  PeopleRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.02.2023.
//

import Foundation

protocol PeopleRouterProtocol: AnyObject {
  func toSendRequestVC(_ user: UserModel)
}

final class PeopleRouter {
  
  init(viewController: PeopleViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: PeopleViewController
  
}

extension PeopleRouter: PeopleRouterProtocol {
  func toSendRequestVC(_ user: UserModel) {
    let sendRequestVC = SendRequestViewController(user: user)
    viewController.present(viewController: sendRequestVC)
  }
  
  
}
