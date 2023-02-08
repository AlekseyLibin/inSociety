//
//  ProfileInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation

protocol ProfileInteractorProtocol: AnyObject {
  func getNumberOfActiveChats(for currentUser: UserModel, completion: @escaping (Result<Int, Error>) -> Void)
  func getNumberOfWaitingChats(for currentUser: UserModel, completion: @escaping (Result<Int, Error>) -> Void)

}

final class ProfileInteractor {
  
}

extension ProfileInteractor: ProfileInteractorProtocol {
  func getNumberOfWaitingChats(for currentUser: UserModel, completion: @escaping (Result<Int, Error>) -> Void) {
    FirestoreService.shared.getNumberOfWaitingChats(for: currentUser, completion: completion)
  }
  
  func getNumberOfActiveChats(for currentUser: UserModel, completion: @escaping (Result<Int, Error>) -> Void) {
    FirestoreService.shared.getNumberOfActiveChats(for: currentUser, completion: completion)
  }
  
}
