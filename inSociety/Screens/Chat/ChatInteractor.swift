//
//  ChatInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol ChatInteractorProtocol: AnyObject {
  func report(_ friend: UserModel, by user: UserModel, with message: String, failureCompletion: @escaping (Error?) -> Void)
  func activeChat(_ chat: ChatModel, for currentUser: UserModel, block flag: Bool, failureCompletion: @escaping (Error?) -> Void)
  func activeChat(deleteEverywhere chat: ChatModel, by currentUser: UserModel, failureCompletion: @escaping (Error?) -> Void)
}

final class ChatInteractor {
  
}

extension ChatInteractor: ChatInteractorProtocol {
  func report(_ friend: UserModel, by user: UserModel, with message: String, failureCompletion: @escaping (Error?) -> Void) {
    FirestoreService.shared.report(friend, by: user, with: message, failureCompletion: failureCompletion)
  }
  
  func activeChat(_ chat: ChatModel, for currentUser: UserModel, block flag: Bool, failureCompletion: @escaping (Error?) -> Void) {
    FirestoreService.shared.activeChat(chat, for: currentUser, block: flag, failureCompletion: failureCompletion)
  }
  
  func activeChat(deleteEverywhere chat: ChatModel, by currentUser: UserModel, failureCompletion: @escaping (Error?) -> Void) {
    FirestoreService.shared.activeChat(deleteEverywhere: chat, by: currentUser, failureCompletion: failureCompletion)
  }
  
}
