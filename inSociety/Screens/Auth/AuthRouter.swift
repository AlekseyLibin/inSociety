//
//  AuthRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth

protocol AuthRouterProtocol: AnyObject {
  func toSignUpVC()
  func toLoginVC()
	func toSetupProfileVC(currentUser: User, appleIdUserName: String?)
  func toMainVC(currentUser: UserModel)
}

final class AuthRouter {
  
  private unowned let viewController: AuthViewControllerProtocol
  
	init(viewController: AuthViewControllerProtocol) {
    self.viewController = viewController
  }
  
}

// MARK: AuthRouterProtocol
extension AuthRouter: AuthRouterProtocol {
  
  func toSignUpVC() {
    let signUpVC = SignUpViewController { [weak self] in
      self?.toLoginVC()
    }
    viewController.present(signUpVC, animated: true, completion: nil)
  }
  
  func toLoginVC() {
    let loginVC = LoginViewController { [weak self] in
      self?.toSignUpVC()
    }
    viewController.present(loginVC, animated: true, completion: nil)
  }
  
	func toSetupProfileVC(currentUser: User, appleIdUserName: String?) {
		let setupProfileVC = SetupProfileViewController(target: .create(firebaseUser: currentUser, appleIdUserName: appleIdUserName))
    viewController.present(setupProfileVC, animated: true, completion: nil)
  }
  
  func toMainVC(currentUser: UserModel) {
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
				windowScene.windows.first?.rootViewController = MainTabBarController(currentUser: currentUser)
		viewController.navigationController?.setViewControllers([], animated: true)
  }
}
