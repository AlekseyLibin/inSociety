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
  func editButtonPressed()
  func logOutButtonPressed()
  var interactor: ProfileInteractorProtocol! { get set }
  var router: ProfileRouterProtocol! { get set }
}

final class ProfilePresenter {
  
  private let viewController: ProfileViewControllerProtocol
  var interactor: ProfileInteractorProtocol!
  var router: ProfileRouterProtocol!
  
  init(viewController: ProfileViewControllerProtocol) {
    self.viewController = viewController
  }
}

extension ProfilePresenter: ProfilePresenterProtocol {
  func fillUpActualInformation() {
    interactor.getDataForCurrentUser { [weak self] result in
      switch result {
      case .success(let currentUserModel):
        self?.viewController.updateViews(with: currentUserModel)
      case .failure(let failure):
        self?.viewController.showAlert(with: ProfileString.error.localized, and: failure.localizedDescription)
      }
    }
  }
  
  func fillChatsInformation(by currentUser: UserModel) {
    interactor.getNumberOfActiveChats(for: currentUser) { [weak self] result in
      switch result {
      case .success(let count):
        self?.viewController.activeChats(changeQuantity: count)
      case .failure(let error):
        self?.viewController.showAlert(with: ProfileString.noActiveChatsQuantity.localized, and: error.localizedDescription)
      }
    }
    interactor.getNumberOfWaitingChats(for: currentUser) { [weak self] result in
      switch result {
      case .success(let count):
        self?.viewController.waitingChats(changeQuantity: count)
      case .failure(let error):
        self?.viewController.showAlert(with: ProfileString.noWaitingChatsQuantity.localized, and: error.localizedDescription)
      }
    }
  }
  
  func editButtonPressed() {
    if let user = Auth.auth().currentUser {
      router.toSetupProfileVC(with: user)
    } else {
      viewController.showAlert(with: ProfileString.error.localized, and: ProfileString.userNotFound.localized)
    }
  }
  
  func logOutButtonPressed() {
    let alertController = UIAlertController(title: ProfileString.logOutWarning.localized, message: nil, preferredStyle: .actionSheet)
    
    let logOutAction = UIAlertAction(title: ProfileString.logOut.localized, style: .destructive, handler: { _ in
      do {
        try self.interactor.logOut()
      } catch {
        self.viewController.showAlert(with: ProfileString.error.localized, and: error.localizedDescription)
      }
    })
    let cancelAction = UIAlertAction(title: ProfileString.cancel.localized, style: .cancel)
    cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
    
    alertController.addAction(logOutAction)
    alertController.addAction(cancelAction)
    viewController.present(viewController: alertController)
  }
    
  }
  
