//
//  ChatsInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 04.02.2023.
//

import Foundation

protocol ChatsInteractorProtocol: AnyObject {
  func waitingChat(moveToActive chat: ChatModel, completion:  @escaping (Result<Void, Error>) -> Void)
  func waitingChat(remove chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void)
  func updateActiveChats(completion: @escaping (Result<[ChatModel], Error>) -> Void)
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
  
  func updateActiveChats(completion: @escaping (Result<[ChatModel], Error>) -> Void) {
    FirestoreService.shared.updateActiveChats(completion: completion)
  }
  
}
