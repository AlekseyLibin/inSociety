//
//  ChatPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation
import FirebaseFirestore

protocol ChatPresenterProtocol: AnyObject {
  func messagesListener(for chat: ChatModel, observe completion: @escaping(Result<ListenerService.UpdatedMessageStatus, Error>) -> Void) -> ListenerRegistration
  func report(_ friend: UserModel, by user: UserModel)
  func block(_ chat: ChatModel, by user: UserModel)
  func delete(_ chat: ChatModel, by user: UserModel)
}

final class ChatPresenter {
  init(viewController: ChatViewControllerProtocol) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ChatViewControllerProtocol
  var interactor: ChatInteractorProtocol!
  var router: ChatRouterProtocol!
}

extension ChatPresenter: ChatPresenterProtocol {
  func messagesListener(for chat: ChatModel, observe completion: @escaping(Result<ListenerService.UpdatedMessageStatus, Error>) -> Void) -> ListenerRegistration {
    return ListenerService.shared.messages(for: chat, observe: completion)
  }
  
  func report(_ friend: UserModel, by currentUser: UserModel) {
    let alertController = UIAlertController(title: "\(ChatString.report.localized) \(friend.fullName)", message: ChatString.describeTheProblem.localized, preferredStyle: .alert)
    alertController.addTextField { textField in
      textField.placeholder = ChatString.report.localized
    }
    
    let submitAction = UIAlertAction(title: ChatString.submit.localized, style: .default) { [weak self] _ in
      guard let text = alertController.textFields?.first?.text, let self else { return }
      self.interactor.report(friend, by: currentUser, with: text, failureCompletion: self.showResultAlert)
    }
    
    let cancelAction = UIAlertAction(title: ChatString.cancel.localized, style: .cancel)
    cancelAction.setValue(UIColor.white, forKey: "titleTextColor")
    
    alertController.addAction(submitAction)
    alertController.addAction(cancelAction)
    viewController.present(alertController, animated: true, completion: nil)
  }
  
  func block(_ chat: ChatModel, by user: UserModel) {
    interactor.activeChat(chat, for: user, block: true) { [weak self] error in
      if let error {
        let alertController = UIAlertController(title: ChatString.error.localized, message: error.localizedDescription, preferredStyle: .alert)
        let submitButton = UIAlertAction(title: ChatString.submit.localized, style: .default)
        alertController.addAction(submitButton)
        self?.viewController.present(alertController, animated: true, completion: nil)
      } else {
        self?.viewController.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  func delete(_ chat: ChatModel, by user: UserModel) {
    let alertController = UIAlertController(title: ChatString.deleteChat.localized, message: "\(ChatString.deleteWarningPt1.localized) \(chat.friend.fullName)? \(ChatString.deleteWarningPt2.localized)", preferredStyle: .alert)
    let deleteButton = UIAlertAction(title: ChatString.delete.localized, style: .destructive) { _ in
      self.interactor.activeChat(deleteEverywhere: chat, by: user) { [weak self] error in
        if let error {
          let alertController = UIAlertController(title: ChatString.error.localized, message: error.localizedDescription, preferredStyle: .alert)
          let submitButton = UIAlertAction(title: ChatString.submit.localized, style: .default)
          alertController.addAction(submitButton)
          self?.viewController.present(alertController, animated: true, completion: nil)
        } else {
          self?.viewController.navigationController?.popViewController(animated: true)
        }
      }
    }
    let cancelButton = UIAlertAction(title: ChatString.cancel.localized, style: .default)
    cancelButton.setValue(UIColor.white, forKey: "titleTextColor")
    alertController.addAction(cancelButton)
    alertController.addAction(deleteButton)
    viewController.present(alertController, animated: true, completion: nil)
  }
  
  func showResultAlert(by error: Error?) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    if let error {
      alertController.title = ChatString.error.localized
      alertController.message = error.localizedDescription
    } else {
      alertController.title = ChatString.success.localized
      alertController.message = ChatString.reportSentSuccessfully.localized
    }
    
    let submitAction = UIAlertAction(title: ChatString.confirm.localized, style: .default)
    alertController.addAction(submitAction)
    viewController.present(alertController, animated: true, completion: nil)
  }
}
