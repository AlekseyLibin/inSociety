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
  func logOutOrDeleteButtonPressed(by currentUser: UserModel)
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
        self?.fillChatsInformation(by: currentUserModel)
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
    router.toSetupProfileVC(with: viewController.currentUser)
  }
  
  func logOutOrDeleteButtonPressed(by currentUser: UserModel) {
    let alertController = UIAlertController(title: ProfileString.logOutOrDeleteWarning.localized, message: nil, preferredStyle: .actionSheet)
    
    let logOutAction = UIAlertAction(title: ProfileString.logOut.localized, style: .destructive) { _ in
      do {
        try self.interactor.logOut()
        self.viewController.generateHapticFeedback(.success)
      } catch {
        self.viewController.generateHapticFeedback(.error)
        self.viewController.showAlert(with: ProfileString.error.localized, and: error.localizedDescription)
      }
    }
    
    let deleteAccountAction = UIAlertAction(title: ProfileString.deleteAccount.localized, style: .destructive) { _ in
      let deleteAccountAlert = UIAlertController(title: ProfileString.deleteAccount.localized, message: ProfileString.deleteWarning.localized, preferredStyle: .alert)
      
      let deleteButton = UIAlertAction(title: ProfileString.confirm.localized, style: .destructive) { _ in
        FirestoreService.shared.profile(delete: currentUser) { [weak self] error in
          if let error = error {
            self?.viewController.showAlert(with: ProfileString.error.localized, and: error.localizedDescription)
          } else {
            do {
              try self?.interactor.logOut()
            } catch {
              self?.viewController.showAlert(with: ProfileString.error.localized, and: error.localizedDescription)
            }
          }
        }
      }
      
      let cancelAction = UIAlertAction(title: ProfileString.cancel.localized, style: .cancel)
      cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
      
      deleteAccountAlert.addAction(deleteButton)
      deleteAccountAlert.addAction(cancelAction)
      self.viewController.present(deleteAccountAlert, animated: true, completion: nil)
    }
    let cancelAction = UIAlertAction(title: ProfileString.cancel.localized, style: .cancel)
    cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
    
    alertController.addAction(logOutAction)
    alertController.addAction(deleteAccountAction)
    alertController.addAction(cancelAction)
    viewController.present(alertController, animated: true, completion: nil)
  }
  
}
