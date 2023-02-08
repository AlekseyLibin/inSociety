//
//  ProfilePresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation
import FirebaseAuth

protocol ProfilePresenterProtocol: AnyObject {
  func fillChatsInformation(by currentUser: UserModel)
  func signOut()
}

final class ProfilePresenter {
  init(viewController: ProfileViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ProfileViewControllerProtocol
  var interactor: ProfileInteractorProtocol!
  var router: ProfileRouterProtocol!
}

extension ProfilePresenter: ProfilePresenterProtocol {
  func fillChatsInformation(by currentUser: UserModel) {
    
    interactor.getNumberOfActiveChats(for: currentUser) { result in
      switch result {
      case .success(let count):
        self.viewController.activeChats(changeQuantity: count)
      case .failure(let error):
        self.viewController.showAlert(with: "Couldn't get active chats quantity", and: error.localizedDescription)
      }
    }
    interactor.getNumberOfWaitingChats(for: currentUser) { result in
      switch result {
      case .success(let count):
        self.viewController.waitingChats(changeQuantity: count)
      case .failure(let error):
        self.viewController.showAlert(with: "Couldn't get waiting chats quantity", and: error.localizedDescription)
      }
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
    } catch {
      self.viewController.showAlert(with: "Error", and: error.localizedDescription)
    }
  }
  
  
}
