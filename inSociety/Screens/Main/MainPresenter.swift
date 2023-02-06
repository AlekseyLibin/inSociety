//
//  MainPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.02.2023.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
  
}

final class MainPresenter {
  
  init(viewController: MainTabBarController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: MainTabBarControllerProtocol
  var interactor: MainInteractorProtocol!
  var router: MainRouterProtocol!
  
}

extension MainPresenter: MainPresenterProtocol {
  
}
