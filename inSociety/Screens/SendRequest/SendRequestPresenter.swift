//
//  SendRequestPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import UIKit

protocol SendRequestPresenterProtocol: AnyObject {
  func sendChatRequest(to user: UserModel, with message: String)
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
  func sendChatRequest(to user: UserModel, with message: String) {
    interactor.createActiveChat(message: message, receiver: user) { [weak self] result in
      self?.viewController.dismiss()
      switch result {
      case .success:
        self?.delegate?.requestSentSuccessfully()
      case .failure(let error):
        self?.delegate?.requestHasNotBeenSent(with: error)
      }
    } errorComplition: { [weak self] error in
      self?.delegate?.requestHasNotBeenSent(with: error)
    }

  }
  
}
