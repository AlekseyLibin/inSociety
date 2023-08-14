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
  func fillUpActualInformation()
  func globeButtonPressed()
  func editButtonPressed()
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
  func fillUpActualInformation() {
    interactor.getDataForCurrentUser { [weak self] result in
      switch result {
      case .success(let currentUserModel):
        self?.viewController.updateViews(with: currentUserModel)
      case .failure(let failure):
        self?.viewController.showAlert(with: "Error", and: failure.localizedDescription)
      }
    }
  }
  
  func fillChatsInformation(by currentUser: UserModel) {
    interactor.getNumberOfActiveChats(for: currentUser) { [weak self] result in
      switch result {
      case .success(let count):
        self?.viewController.activeChats(changeQuantity: count)
      case .failure(let error):
        self?.viewController.showAlert(with: "Couldn't get active chats quantity", and: error.localizedDescription)
      }
    }
    interactor.getNumberOfWaitingChats(for: currentUser) { [weak self] result in
      switch result {
      case .success(let count):
        self?.viewController.waitingChats(changeQuantity: count)
      case .failure(let error):
        self?.viewController.showAlert(with: "Couldn't get waiting chats quantity", and: error.localizedDescription)
      }
    }
  }
  
  func globeButtonPressed() {
    
  }
  
  func editButtonPressed() {
    if let user = Auth.auth().currentUser {
      router.toSetupProfileVC(with: user)
    } else {
      viewController.showAlert(with: "Error", and: "User not found")
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
          windowScene.windows.first?.rootViewController = AuthViewController()
    } catch {
      self.viewController.showAlert(with: "Error", and: error.localizedDescription)
    }
    
  }
  
}
