//
//  ChatsInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 04.02.2023.
//

import Foundation

protocol ChatsInteractorProtocol: AnyObject {
  func waitingChat(moveToActive chat: ChatModel, failureCompletion:  @escaping (Error?) -> Void)
  func waitingChat(remove chat: ChatModel, failureCompletion: @escaping (Error?) -> Void)
  func updateActiveChats(completion: @escaping (Result<[ChatModel], Error>) -> Void)
}

final class ChatsInteractor {
  
}

extension ChatsInteractor: ChatsInteractorProtocol {
  func waitingChat(moveToActive chat: ChatModel, failureCompletion: @escaping (Error?) -> Void) {
    FirestoreService.shared.waitingChat(moveToActive: chat, failureCompletion: failureCompletion)
  }
  
  func waitingChat(remove chat: ChatModel, failureCompletion: @escaping (Error?) -> Void) {
    FirestoreService.shared.waitingChat(refuse: chat, failureCompletion: failureCompletion)
  }
  
  func updateActiveChats(completion: @escaping (Result<[ChatModel], Error>) -> Void) {
    FirestoreService.shared.activeChats(update: completion)
  }
  
}
