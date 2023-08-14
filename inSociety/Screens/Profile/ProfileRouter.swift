//
//  ProfileRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import FirebaseAuth

protocol ProfileRouterProtocol: AnyObject {
  func toLanguagesVC()
  func toSetupProfileVC(with user: User)
}

final class ProfileRouter {
  init(viewController: ProfileViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ProfileViewController
}

extension ProfileRouter: ProfileRouterProtocol {
  func toLanguagesVC() {
    
  }
  
  func toSetupProfileVC(with user: User) {
    let setupProfileViewController = SetupProfileViewController(currentUser: user, target: .modify)
    viewController.navigationController?.pushViewController(setupProfileViewController, animated: true)
  }
  
  
}
