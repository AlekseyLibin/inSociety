//
//  SendRequestInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol SendRequestInteractorProtocol: AnyObject {
  func createActiveChat(message: MessageModel, receiver: UserModel, completion failureCompletion: @escaping (Error?) -> Void)
}

final class SendRequestInteractor {
  
}

extension SendRequestInteractor: SendRequestInteractorProtocol {
  func createActiveChat(message: MessageModel, receiver: UserModel, completion failureCompletion: @escaping (Error?) -> Void) {
    FirestoreService.shared.waitingChat(createBy: message, receiver: receiver) { result in
      switch result {
      case .success:
        guard let currentUser = FirestoreService.shared.currentUser else { return }
        let chat = ChatModel(friend: receiver, messages: [message])
        FirestoreService.shared.activeChat(createBy: chat, messages: [message], failureCompletion: failureCompletion)
      case .failure(let error):
        failureCompletion(error)
      }
    }
  }
  
}
