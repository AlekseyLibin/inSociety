//
//  ChatPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation
import FirebaseFirestore

protocol ChatPresenterProtocol: AnyObject {
  func messagesListener(by chat: ChatModel, completion: @escaping(Result<MessageModel, Error>) -> Void) -> ListenerRegistration
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
  
  func messagesListener(by chat: ChatModel, completion: @escaping (Result<MessageModel, Error>) -> Void) -> ListenerRegistration {
    return ListenerService.shared.messagesObserve(chat: chat, completion: completion)
  }
  
}
