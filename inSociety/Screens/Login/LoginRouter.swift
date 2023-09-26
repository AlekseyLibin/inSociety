//
//  LoginRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth

protocol LoginRouterProtocol {
  func toSetupProfileVC(currentUser: User)
  func toMainVC(currentUser: UserModel)
}

final class LoginRouter {
  init(viewController: BaseViewController) {
    self.viewController = viewController
  }
  
  private unowned var viewController: BaseViewController
}

extension LoginRouter: LoginRouterProtocol {
  
  func toSetupProfileVC(currentUser: User) {
    let setupProfileVC = SetupProfileViewController(target: .create(firebaseUser: currentUser))
    viewController.present(setupProfileVC, animated: true, completion: nil)
  }
  
  func toMainVC(currentUser: UserModel) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    windowScene.windows.first?.rootViewController = MainTabBarController(currentUser: currentUser)
    viewController.navigationController?.setViewControllers([], animated: true)
  }
  
}
