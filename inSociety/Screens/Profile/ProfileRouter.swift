//
//  ProfileRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol ProfileRouterProtocol: AnyObject {
  
}

final class ProfileRouter {
  init(viewController: ProfileViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ProfileViewController
}

extension ProfileRouter: ProfileRouterProtocol {
  
}
