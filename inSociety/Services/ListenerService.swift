//
//  ListenerService.swift
//  inSociety
//
//  Created by Aleksey Libin on 25.10.2022.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

final class ListenerService {
  static let shared = ListenerService()
  private init() {}
  
  private let dataBase = Firestore.firestore()
  private var usersReference: CollectionReference {
    return dataBase.collection("users")
  }
  private var currentUserId: String {
    return Auth.auth().currentUser!.uid
  }
  
  func usersObserve(users: [UserModel], completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration? {

    var allUsers = users 
    let usersListener = usersReference.addSnapshotListener { [weak self] querySnapshot, error in
      guard let self = self else { return }
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
            newUser.id != self.currentUserId
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
  
  func waitingChatsObserve(chats: [ChatModel], completion: @escaping(Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
    
    var allChats = chats
    let chatsReference = dataBase.collection("users/\(currentUserId)/waitingChats")
    let chatsListener = chatsReference.addSnapshotListener { querySnapshot, error in
      guard let querySnapshot = querySnapshot else {
        completion(.failure(error!))
        return
      }
      
      querySnapshot.documentChanges.forEach { difference in
        guard let modifiedChat = ChatModel(document: difference.document) else { return }
        switch difference.type {
        case .added:
          guard
            !allChats.contains(modifiedChat)
          else { return }
          allChats.append(modifiedChat)
        case .modified:
          guard let index = allChats.firstIndex(of: modifiedChat) else { return }
          allChats[index] = modifiedChat
        case .removed:
          guard let index = allChats.firstIndex(of: modifiedChat) else { return }
          allChats.remove(at: index)
        }
      }
      completion(.success(allChats))
    }
    
    return chatsListener
  }
  
  func activeChatsObserve(chats: [ChatModel], completion: @escaping(Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
    
    var allChats = chats
    let chatsReference = dataBase.collection("users/\(currentUserId)/activeChats")
    let chatsListener = chatsReference.addSnapshotListener { querySnapshot, error in
      guard let querySnapshot = querySnapshot else {
        completion(.failure(error!))
        return
      }
      
      querySnapshot.documentChanges.forEach { difference in
        guard let modifiedChat = ChatModel(document: difference.document) else { return }
        switch difference.type {
        case .added:
          guard
            !allChats.contains(modifiedChat)
          else { return }
          allChats.append(modifiedChat)
        case .modified:
          guard let index = allChats.firstIndex(of: modifiedChat) else { return }
          allChats[index] = modifiedChat
        case .removed:
          guard let index = allChats.firstIndex(of: modifiedChat) else { return }
          allChats.remove(at: index)
        }
      }
      completion(.success(allChats))
    }
    return chatsListener
  }
  
  func messagesObserve(chat: ChatModel, completion: @escaping(Result<MessageModel, Error>) -> Void) -> ListenerRegistration {
    let reference = usersReference.document(currentUserId).collection("activeChats").document(chat.friendID).collection("messages")
    let messagesListener = reference.addSnapshotListener { snapshot, error in
      guard let snapshot = snapshot else {
        completion(.failure(error!))
        return
      }
      snapshot.documentChanges.forEach { difference in
        guard let message = MessageModel(document: difference.document) else { return }
        switch difference.type {
        case .added:
          completion(.success(message))
        case .modified:
          // TODO: any additional actions to expand project
          break
        case .removed:
          // TODO: any additional actions to expand project
          break
        }
      }
    }
    
    return messagesListener
  }
}
