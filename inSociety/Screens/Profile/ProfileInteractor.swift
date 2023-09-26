//
//  ProfileInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 06.02.2023.
//

import Foundation
import FirebaseAuth

protocol ProfileInteractorProtocol: AnyObject {
  func getNumberOfActiveChats(for currentUser: UserModel, completion: @escaping (Result<Int, Error>) -> Void)
  func getNumberOfWaitingChats(for currentUser: UserModel, completion: @escaping (Result<Int, Error>) -> Void)
  func getDataForCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void)
  func logOut() throws
  func deleteCurrentUser()
}

final class ProfileInteractor {
  
}

extension ProfileInteractor: ProfileInteractorProtocol {
  func getDataForCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void) {
    FirestoreService.shared.getCurrentUserModel(completion: completion)
  }
  
  func getNumberOfWaitingChats(for currentUser: UserModel, completion: @escaping (Result<Int, Error>) -> Void) {
    FirestoreService.shared.waitingChats(getAmountFor: currentUser, completion: completion)
  }
  
  func getNumberOfActiveChats(for currentUser: UserModel, completion: @escaping (Result<Int, Error>) -> Void) {
    FirestoreService.shared.activeChats(getAmountFor: currentUser, completion: completion)
  }
  
  func logOut() throws {
    try Auth.auth().signOut()
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.rootViewController = AuthViewController()
  }
  
  func deleteCurrentUser() { }
  
}
