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
  func checkNoChats(with friend: UserModel, completion: @escaping (Result<Void, Error>) -> Void)
}

final class PeopleInteractor {
  
}

extension PeopleInteractor: PeopleInteractorProtocol {
  
  func usersObserve(users: [UserModel], completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration? {
    return ListenerService.shared.usersObserve(users: users, completion: completion)
  }
  
  func checkNoChats(with friend: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
    FirestoreService.shared.checkNoChats(with: friend, completion: completion)
  }
}
