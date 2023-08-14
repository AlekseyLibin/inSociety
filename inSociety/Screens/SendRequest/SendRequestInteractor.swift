//
//  SendRequestInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol SendRequestInteractorProtocol: AnyObject {
  func createActiveChat(message: String, receiver: UserModel, completion: @escaping (Result<Void, Error>) -> Void, errorComplition: @escaping (Error) -> Void)
}

final class SendRequestInteractor {
  
}

extension SendRequestInteractor: SendRequestInteractorProtocol {
  func createActiveChat(message: String, receiver: UserModel, completion: @escaping (Result<Void, Error>) -> Void, errorComplition: @escaping (Error) -> Void) {
    FirestoreService.shared.createWaitingChat(message: message, receiver: receiver) { result in
      switch result {
      case .success:
        guard let currentUser = FirestoreService.shared.currentUser else { return }
        let chat = ChatModel(friendName: receiver.fullName,
                             friendAvatarString: receiver.avatarString,
                             lastMessageContent: message, friendID: receiver.id)
        
        let message = MessageModel(user: currentUser, content: message)
        FirestoreService.shared.createActiveChat(chat: chat, messages: [message], completion: completion)
      case .failure(let error):
        errorComplition(error)
      }
    }
  }
  
}
