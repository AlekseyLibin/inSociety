//
//  ChatsInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 04.02.2023.
//

import Foundation

protocol ChatsInteractorProtocol: AnyObject {
  func getLastMessage(chat: ChatModel, completion: @escaping (Result<MessageModel, Error>) -> Void)
  func waitingChat(moveToActive chat: ChatModel, completion:  @escaping (Result<Void, Error>) -> Void)
  func waitingChat(remove chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ChatsInteractor {
  
}

extension ChatsInteractor: ChatsInteractorProtocol {
  func waitingChat(moveToActive chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
    FirestoreService.shared.moveWaitingChatToActive(chat: chat, completion: completion)
  }
  
  func waitingChat(remove chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
    FirestoreService.shared.deleteWaitingChat(chat: chat, completion: completion)
  }
  
  func getLastMessage(chat: ChatModel, completion: @escaping (Result<MessageModel, Error>) -> Void) {
    FirestoreService.shared.getLastMessage(chat: chat, completion: completion)
  }
  
}
