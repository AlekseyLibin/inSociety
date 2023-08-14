//
//  SendRequestPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import UIKit

protocol SendRequestPresenterProtocol: AnyObject {
  func sendChatRequest(to user: UserModel, with message: String)
}

final class SendRequestPresenter {
  init(viewController: SendRequestViewControllerProtocol) {
    self.viewController = viewController
  }
  
  private unowned let viewController: SendRequestViewControllerProtocol
  var interactor: SendRequestInteractorProtocol!
  var router: SendRequestRouterProtocol!
}

extension SendRequestPresenter: SendRequestPresenterProtocol {
  
  func sendChatRequest(to user: UserModel, with message: String) {
    interactor.createActiveChat(message: message, receiver: user) { result in
      self.viewController.removeActivityIndicator()
      switch result {
      case .success:
        UIApplication.getTopViewController()?.showAlert(with: "Success", and: "Your message and chat request have been sent to \(user.fullName)", completion: {
          self.viewController.dismiss()
        })
      case.failure(let error):
        UIApplication.getTopViewController()?.showAlert(with: "Error", and: error.localizedDescription, completion: {
          self.viewController.dismiss()
        })
      }
    } errorComplition: { error in
      self.viewController.removeActivityIndicator()
      UIApplication.getTopViewController()?.showAlert(with: "Error", and: error.localizedDescription, completion: {
        self.viewController.dismiss()
      })
    }

  }
  
}
