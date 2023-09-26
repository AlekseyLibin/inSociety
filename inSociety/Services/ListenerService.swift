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
  
  enum UpdatedMessageStatus {
    case added(MessageModel)
    case modified(MessageModel)
    case removed(MessageModel)
  }
  
  static let shared = ListenerService()
  private init() {}
  
  private let dataBase = Firestore.firestore()
  private var usersReference: CollectionReference {
    return dataBase.collection("users")
  }
  private var currentUser: User {
    return Auth.auth().currentUser!
  }
  
  /// Sets and returns Users observer
  func users(observe users: [UserModel], _ completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration? {
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
            newUser.id != self.currentUser.uid
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
  
  /// Sets and returns waiting chats observer
  func waitingChats(observe chats: [ChatModel], _ completion: @escaping(Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
    var allChats = chats
    let chatsReference = dataBase.collection("users/\(currentUser.email!)/waitingChats")
    let chatsListener = chatsReference.addSnapshotListener { querySnapshot, error in
      guard let querySnapshot = querySnapshot else {
        completion(.failure(error!))
        return
      }
      
      querySnapshot.documentChanges.forEach { difference in
        guard let modifiedChat = ChatModel(document: difference.document) else { return }
        switch difference.type {
        case .added:
          if !allChats.contains(modifiedChat) {
            allChats.append(modifiedChat)
          } else { break }
        case .modified:
          if let index = allChats.firstIndex(of: modifiedChat) {
            allChats[index] = modifiedChat
          } else {  break  }
        case .removed:
          allChats = allChats.filter({ $0.friend.id != modifiedChat.friend.id })
        }
        completion(.success(allChats.sorted()))
      }
    }
    return chatsListener
  }
  
  /// Sets and returns actve chats observer
  func activeChats(observe chats: [ChatModel], _ completion: @escaping(Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
    var allChats = [ChatModel]()
    let chatsReference = dataBase.collection("users/\(currentUser.email!)/activeChats")
    let chatsListener = chatsReference.addSnapshotListener { querySnapshot, error in
      guard let querySnapshot = querySnapshot else {
        completion(.failure(error!))
        return
      }
      
      querySnapshot.documentChanges.forEach { difference in
        guard let modifiedChat = ChatModel(document: difference.document) else { return }
        switch difference.type {
        case .added:
          if !allChats.contains(modifiedChat) {
            allChats.append(modifiedChat)
          } else { break }
        case .modified:
          if let chatToModify = allChats.filter({ $0.friend.id == modifiedChat.friend.id }).first,
             let index = allChats.firstIndex(of: chatToModify) {
            allChats[index] = modifiedChat
          } else {  break  }
        case .removed:
          allChats = allChats.filter({ $0.friend.id != modifiedChat.friend.id })
        }
        completion(.success(allChats.sorted()))
      }
    }
    return chatsListener
  }
  
  /// Sets and returns inactve chats observer
  func inactiveChats(observe chats: [ChatModel], _ completion: @escaping(Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
    var allChats = [ChatModel]()
    let chatsReference = dataBase.collection("users/\(currentUser.email!)/inactiveChats")
    let chatsListener = chatsReference.addSnapshotListener { querySnapshot, error in
      guard let querySnapshot = querySnapshot else {
        completion(.failure(error!))
        return
      }
      
      querySnapshot.documentChanges.forEach { difference in
        guard let modifiedChat = ChatModel(document: difference.document) else { return }
        switch difference.type {
        case .added:
          if !allChats.contains(modifiedChat) {
            allChats.append(modifiedChat)
          } else { break }
        case .modified:
          if let index = allChats.firstIndex(of: modifiedChat) {
            allChats[index] = modifiedChat
          } else {  break  }
        case .removed:
          allChats = allChats.filter({ $0.friend.id != modifiedChat.friend.id })
        }
        completion(.success(allChats.sorted()))
      }
    }
    return chatsListener
  }
  
  /// Sets and returns messages for certain chat observer
  func messages(for chat: ChatModel, observe completion: @escaping(Result<UpdatedMessageStatus, Error>) -> Void) -> ListenerRegistration {
    let reference = usersReference.document(currentUser.email!).collection("activeChats").document(chat.friend.email).collection("messages")
    let messagesListener = reference.addSnapshotListener { snapshot, error in
      guard let snapshot = snapshot else {
        completion(.failure(error!))
        return
      }
      
      snapshot.documentChanges.forEach { difference in
        guard let message = MessageModel(document: difference.document) else { return }
        switch difference.type {
        case .added:
          if let readMessage = chat.messages.filter({ $0.messageId == message.messageId && $0.read != message.read }).first {
            completion(.success(.modified(readMessage)))
          } else { completion(.success(.added(message))) }
        case .modified:
          guard !chat.messages.filter({ $0.messageId == message.messageId && $0.read != message.read }).isEmpty else { return }
          completion(.success(.modified(message)))
        case .removed:
          completion(.success(.removed(message)))
        }
      }
    }
    
    return messagesListener
  }
}
