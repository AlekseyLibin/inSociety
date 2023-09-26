//
//  SetupProfilePresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import UIKit
import FirebaseAuth

protocol SetupProfilePresenterProtocol: AnyObject {
  func fillAvailableDataForCurrentUser(by target: SetupProfileViewController.Target)
  func submitButtonPressed(with newUser: SetupNewUser)
}

final class SetupProfilePresenter {
  
  private unowned let viewController: SetupProfileViewControllerProtocol
  var interactor: SetupProfileInteractorProtocol!
  var router: SetupProfileRouterProtocol!
  
  init(viewController: SetupProfileViewControllerProtocol) {
    self.viewController = viewController
  }
  
}

extension SetupProfilePresenter: SetupProfilePresenterProtocol {
  func fillAvailableDataForCurrentUser(by target: SetupProfileViewController.Target) {
    switch target {
    case .create:
      break
    case .modify:
      interactor.getDataForCurrentUser { [weak self] result in
        switch result {
        case .success(let userModel):
          self?.viewController.updateViews(with: userModel)
        case .failure(let failure):
          print(failure.localizedDescription)
        }
      }
    }
  }
  
  func submitButtonPressed(with newUser: SetupNewUser) {
    interactor.submitButtonPressed(with: newUser) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let currentUserModel):
        switch viewController.target {
        case .create:
          self.viewController.generateHapticFeedback(.success)
          self.router.toMainVC(currentUser: currentUserModel)
        case .modify:
          self.viewController.generateHapticFeedback(.success)
          self.router.backToProfileVC()
        }
      case .failure(let error):
        self.viewController.generateHapticFeedback(.error)
        self.viewController.showAlert(with: SetupProfileString.error.localized, and: error.localizedDescription, completion: {})
      }
    }
  }
  
}
