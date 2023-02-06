//
//  MainRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.02.2023.
//

import Foundation

protocol MainRouterProtocol: AnyObject {
  
}

final class MainRouter {
  
  init(viewController: MainTabBarController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: MainTabBarController
  
}

extension MainRouter: MainRouterProtocol {
  
}
