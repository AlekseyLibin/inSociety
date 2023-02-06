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
    
    var allUsers = users
    let usersListener = Firestore.firestore().collection("users").addSnapshotListener { querySnapshot, error in
      guard let snapshot = querySnapshot else {
        completion(.failure(error!))
        return
      }
      
      snapshot.documentChanges.forEach { difference in
        guard let newUser = UserModel(queryDocument: difference.document) else { return }
        switch difference.type {
        
        case .added:
          guard
            !allUsers.contains(newUser),
            newUser.id != Auth.auth().currentUser!.uid
          else { return }
          allUsers.append(newUser)
        case .modified:
          guard let index = allUsers.firstIndex(of: newUser) else { return }
          allUsers[index] = newUser
        case .removed:
          guard let index = allUsers.firstIndex(of: newUser) else { return }
          allUsers.remove(at: index)
        }
      }
      completion(.success(allUsers))
    }
    return usersListener
  }
  
  func checkNoChats(with friend: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
    let activeChatMessages = Firestore.firestore().collection("users/\(FirestoreService.shared.currentUserModel.id)/activeChats").document(friend.id).collection("messages")
    activeChatMessages.getDocuments { snapshot, error in
      guard let snapshot = snapshot else {
        completion(.failure(error!))
        return
      }
      
      if snapshot.documents.isEmpty {
        let waitingChatMessages = Firestore.firestore().collection("users/\(FirestoreService.shared.currentUserModel.id)/waitingChats").document(friend.id).collection("messages")
        waitingChatMessages.getDocuments { snapshot, error in
          guard let snapshot = snapshot else {
            completion(.failure(error!))
            return
          }
          
          if snapshot.documents.isEmpty {
            completion(.success(Void()))
          } else {
            completion(.failure(UserError.chatAlreadyExists))
          }
        }
      } else {
        completion(.failure(UserError.chatAlreadyExists))
      }
    }
  }
}
