//
//  SendRequestPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import UIKit

protocol SendRequestPresenterProtocol: AnyObject {
  func sendChatRequest(to user: UserModel, with message: MessageModel)
  var delegate: SendRequestPresenterDelegate? { get set }
}

protocol SendRequestPresenterDelegate: AnyObject {
  func requestSentSuccessfully()
  func requestHasNotBeenSent(with error: Error)
}

final class SendRequestPresenter {
  init(viewController: SendRequestViewControllerProtocol) {
    self.viewController = viewController
  }
  
  private unowned let viewController: SendRequestViewControllerProtocol
  weak var delegate: SendRequestPresenterDelegate?
  var interactor: SendRequestInteractorProtocol!
  var router: SendRequestRouterProtocol!
}

extension SendRequestPresenter: SendRequestPresenterProtocol {
  func sendChatRequest(to user: UserModel, with message: MessageModel) {
    interactor.createActiveChat(message: message, receiver: user) { [weak self] error in
      self?.viewController.dismiss(animated: true, completion: nil)
      if let error = error {
        self?.delegate?.requestHasNotBeenSent(with: error)
      } else {
        self?.delegate?.requestSentSuccessfully()
      }
    }
  }
}
