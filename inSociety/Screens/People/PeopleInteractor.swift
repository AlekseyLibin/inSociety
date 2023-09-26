//
//  PeopleInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.02.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol PeopleInteractorProtocol: AnyObject {
  func usersObserve(users: [UserModel], completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration?
  func waitingChat(moveToActive chat: ChatModel, failureCompletion:  @escaping (Error?) -> Void)
  func waitingChat(remove chat: ChatModel, failureCompletion: @escaping (Error?) -> Void)
  func activeChat(_ chat: ChatModel, for currentUser: UserModel, block flag: Bool, failureCompletion: @escaping (Error?) -> Void)
}

final class PeopleInteractor {
  
}

extension PeopleInteractor: PeopleInteractorProtocol {
  func usersObserve(users: [UserModel], completion: @escaping (Result<[UserModel], Error>) -> Void) -> ListenerRegistration? {
    return ListenerService.shared.users(observe: users, completion)
  }
  
  func waitingChat(moveToActive chat: ChatModel, failureCompletion: @escaping (Error?) -> Void) {
    FirestoreService.shared.waitingChat(moveToActive: chat, failureCompletion: failureCompletion)
  }

  func waitingChat(remove chat: ChatModel, failureCompletion: @escaping (Error?) -> Void) {
    FirestoreService.shared.waitingChat(refuse: chat, failureCompletion: failureCompletion)
  }
  
  func activeChat(_ chat: ChatModel, for currentUser: UserModel, block flag: Bool, failureCompletion: @escaping (Error?) -> Void) {
    FirestoreService.shared.activeChat(chat, for: currentUser, block: flag, failureCompletion: failureCompletion)
  }
}
