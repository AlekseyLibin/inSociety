//
//  ProfileRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import FirebaseAuth

protocol ProfileRouterProtocol: AnyObject {
  func toSetupProfileVC(with currentUser: UserModel)
}

final class ProfileRouter {
  init(viewController: ProfileViewController) {
    self.viewController = viewController
    self.setupProfileViewController = SetupProfileViewController(target: .modify(currentUserModel: viewController.currentUser))
  }
  
  private let viewController: ProfileViewController
  private let setupProfileViewController: SetupProfileViewController
}

extension ProfileRouter: ProfileRouterProtocol {
  
  func toSetupProfileVC(with currentUser: UserModel) {
    viewController.navigationController?.pushViewController(setupProfileViewController, animated: true)
  }
  
}
