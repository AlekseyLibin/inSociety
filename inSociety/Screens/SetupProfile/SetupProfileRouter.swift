//
//  SetupProfileRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import UIKit

protocol SetupProfileRouterProtocol {
  func toMainVC(currentUser: UserModel)
  func backToProfileVC()
}

final class SetupProfileRouter {
  
  private unowned let viewController: BaseViewController
  
  init(viewController: BaseViewController!) {
    self.viewController = viewController
  }
}

extension SetupProfileRouter: SetupProfileRouterProtocol {
  func toMainVC(currentUser: UserModel) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    viewController.navigationController?.setViewControllers([], animated: true)
      windowScene.windows.first?.rootViewController = MainTabBarController(currentUser: currentUser)
  }
  
  func backToProfileVC() {
    viewController.navigationController?.popViewController(animated: true)
  }
  
}
