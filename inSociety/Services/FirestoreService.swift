//
//  FirestoreService.swift
//  inSociety
//
//  Created by Aleksey Libin on 21.10.2022.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

final class FirestoreService {
  
  static let shared = FirestoreService()
  private init() { }
  
  /// Firebase Firestore database used to keep users information and messages
  private let dataBase = Firestore.firestore()
  var currentUser: UserModel!
  
  /// Reference to waiting chats collection by current user
  private var waitingChatsReference: CollectionReference {
    return dataBase.collection("users/\(currentUser.email)/waitingChats")
  }
  
  /// Reference to active chats collection by current user
  private var activeChatsReference: CollectionReference {
    return dataBase.collection("users/\(currentUser.email)/activeChats")
  }
  
}

// MARK: - User
extension FirestoreService {
  /// Returns completion block with UserModel representaion of current user
  func getCurrentUserModel(completion: @escaping (Result<UserModel, Error>) -> Void) {
    guard let currentUser = Auth.auth().currentUser else {
      completion(.failure(UserError.cannotGetUserInfo))
      return
    }
    
    let documentReference = dataBase.collection("users").document(currentUser.email!)
    documentReference.getDocument { document, _ in
      if let document = document, document.exists {
        guard let user = UserModel(document: document) else {
          completion(.failure(UserError.cannotUnwrapFBDataToUserModel))
          return
        }
        self.currentUser = user
        completion(.success(user))
      } else {
        completion(.failure(UserError.cannotGetUserInfo))
      }
    }
  }
  
  /// Saves profile into Firebase Firestore
  func profile(save newUser: SetupNewUser, completion: @escaping (Result<UserModel, Error>) -> Void) {
    guard
      let userName = newUser.name,
      let avatarImage = newUser.avatarImage,
      let aboutMe = newUser.aboutMe,
      let sex = newUser.sex,
      !userName.isEmpty,
      !aboutMe.isEmpty
    else {
      completion(.failure(UserError.fieldsAreNotFilled))
      return
    }
    var userModel = UserModel(userName: userName,
                              userAvatarString: "not exist",
                              email: newUser.email,
                              description: aboutMe,
                              sex: sex,
                              id: newUser.id)
    
    if let currentUser = currentUser {
      let currentAvatarImageView = UIImageView()
      currentAvatarImageView.sd_setImage(with: URL(string: currentUser.avatarString))
      if currentAvatarImageView.image != avatarImage {
        StorageService.shared.image(upload: avatarImage, path: currentUser.email) { [weak self] result in
          switch result {
          case .success(let avatatarURL):
            userModel.avatarString = avatatarURL.absoluteString
            self?.dataBase.collection("users").document(userModel.email).setData(userModel.representationDict) { error in
              if let error = error {
                completion(.failure(error))
              } else {
                completion(.success(userModel))
                self?.currentUser = userModel
              }
            }
          case .failure(let error):
            completion(.failure(error))
          }
        }
      } else {
        userModel.avatarString = currentUser.avatarString
        dataBase.collection("users").document(userModel.email).setData(userModel.representationDict) { [weak self] error in
          if let error = error {
            completion(.failure(error))
          } else {
            completion(.success(userModel))
            self?.currentUser = userModel
          }
        }
      }
    } else {
      guard let userEmail = Auth.auth().currentUser?.email else { return }
      StorageService.shared.image(upload: avatarImage, path: userEmail) { [weak self] result in
        switch result {
        case .success(let avatatarURL):
          userModel.avatarString = avatatarURL.absoluteString
          self?.dataBase.collection("users").document(userModel.email).setData(userModel.representationDict) { error in
            if let error = error {
              completion(.failure(error))
            } else {
              completion(.success(userModel))
              self?.currentUser = userModel
            }
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
  
  /// Sends report for abusive user to Firebase
  func report(_ accused: UserModel, by accuser: UserModel, with message: String, failureCompletion: @escaping (Error?) -> Void) {
    let reportData: [String: Any] = [
      "accused": accused.email,
      "accuser": accuser.email,
      "date": FieldValue.serverTimestamp(),
      "message": message
    ]
    
    dataBase.collection("reports").document().setData(reportData, completion: failureCompletion)
  }
  
  /// Removes user from database
  func profile(delete currentUser: UserModel, failureCompletion: @escaping (Error?) -> Void) {
    guard let user = Auth.auth().currentUser else { return }
    dataBase.collection("users").document(user.email!).delete(completion: failureCompletion)
    StorageService.shared.image(delete: user, failureCompletion: failureCompletion)
    
    activeChats(currentUser, removeAll: failureCompletion)
    waitingChats(currentUser, removeAll: failureCompletion)
    user.delete(completion: failureCompletion)
  }
}

// MARK: - Chats
extension FirestoreService {
  // MARK: - Waiting chats
  /// Creates a waitingChat with provided message
  func waitingChat(createBy message: MessageModel, receiver: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
    let receiverWaitingChatsReference = dataBase.collection("users/\(receiver.email)/waitingChats")
    
    let messageReference = receiverWaitingChatsReference.document(currentUser.email).collection("messages")
    
    let waitingChatForReceiver = ChatModel(friend: currentUser, messages: [message])
    receiverWaitingChatsReference.document(currentUser.email).setData(waitingChatForReceiver.representation) { error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      messageReference.addDocument(data: message.representation) { error in
        if let error = error {
          completion(.failure(error))
          return
        }
        completion(.success(Void()))
      }
    }
  }
  
  /// Deletes waiting chat for friend and active  chat for current user
  func waitingChat(refuse chat: ChatModel, failureCompletion: @escaping (Error?) -> Void) {
    waitingChat(delete: chat, failureCompletion: failureCompletion)
    
    let activeChatsReference = dataBase.collection("users").document(chat.friend.email).collection("activeChats")
    let activeChatMessages = activeChatsReference.document(currentUser.email).collection("messages")
    
    activeChatsReference.document(currentUser.email).delete { failureCompletion($0) }
    
    activeChatMessages.getDocuments { snapshot, error in
      guard error == nil else { failureCompletion(error); return }
      snapshot?.documents.forEach({ document in
        let documentReference = activeChatMessages.document(document.documentID)
        documentReference.delete { failureCompletion($0) }
      })
    }
  }
  
  /// Removes certain waiting chat from database (only for current user)
  func waitingChat(delete chat: ChatModel, failureCompletion: @escaping (Error?) -> Void) {
    waitingChatsReference.document(chat.friend.email).delete { error in
      guard error == nil else { failureCompletion(error); return}
      
      let waitingChatMessages = self.waitingChatsReference.document(chat.friend.email).collection("messages")
      waitingChatMessages.getDocuments { snapshot, error in
        guard error == nil else { failureCompletion(error); return }
        snapshot?.documents.forEach({ document in
          let documentReference = waitingChatMessages.document(document.documentID)
          documentReference.delete { failureCompletion($0) }
        })
      }
    }
  }
  
  /// Removes certain waiting chat for current user and corresponding friend's active chat from database
  func waitingChat(deleteEverywhere chat: ChatModel, by currentUser: UserModel, failureCompletion: @escaping (Error?) -> Void) {
    let waitingChat = dataBase.collection("users/\(currentUser.email)/waitingChats").document(chat.friend.email)
    waitingChat.delete(completion: failureCompletion)
    
    let waitingChatMessages = waitingChat.collection("messages")
    waitingChatMessages.getDocuments { snapshot, error in
      guard error == nil else { failureCompletion(error); return }
      snapshot?.documents.forEach({ document in
        let documentReference = waitingChatMessages.document(document.documentID)
        documentReference.delete { error in
          if let error = error { failureCompletion(error) }
        }
      })
    }
    
    let friendActiveChat = dataBase.collection("users/\(chat.friend.email)/activeChats").document(currentUser.email)
    friendActiveChat.delete { error in
      if let error = error { failureCompletion(error) }
    }
    
    let activeChatMessages = friendActiveChat.collection("messages")
    activeChatMessages.getDocuments { snapshot, error in
      guard error == nil else { failureCompletion(error); return }
      snapshot?.documents.forEach({ document in
        let documentReference = activeChatMessages.document(document.documentID)
        documentReference.delete()
      })
    }
  }
  
  /// Provides a completion block with amount of waiting chats for certain user
  func waitingChats(getAmountFor user: UserModel, completion: @escaping(Result<Int, Error>) -> Void) {
    let waitingChatsReference = dataBase.collection("users/\(user.email)/waitingChats")
    waitingChatsReference.getDocuments { snapshot, error in
      guard let snapshot = snapshot else {
        completion(.failure(error!))
        return
      }
      
      let count = snapshot.documents.count
      completion(.success(count))
    }
  }
  
  /// Removes waiting chat and creates active one by certain ChatModel
  func waitingChat(moveToActive chat: ChatModel, failureCompletion: @escaping (Error?) -> Void) {
    waitingChat(chat, getMessages: ({ [weak self] result in
      switch result {
      case .success(let messages):
        self?.waitingChat(delete: chat) { error in
          if error != nil {
            failureCompletion(error)
          } else {
            self?.activeChat(createBy: chat, messages: messages) { failureCompletion($0) }
          }
        }
      case .failure(let error):
        failureCompletion(error)
      }
    }))
  }
  
  /// Provides with messages for specified waiting chat
  func waitingChat(_ chat: ChatModel, getMessages completion: @escaping (Result<[MessageModel], Error>) -> Void) {
    let messagesReference = waitingChatsReference.document(chat.friend.email).collection("messages")
    var messages = [MessageModel]()
    messagesReference.getDocuments { querySnapshot, error in
      guard let querySnapshot = querySnapshot else {
        completion(.failure(error!))
        return
      }
      
      for document in querySnapshot.documents {
        guard let message = MessageModel(document: document) else { return }
        messages.append(message)
      }
      completion(.success(messages))
    }
  }
  
  /// Removes all waitingChats for user and friends active chats with user
  func waitingChats(_ currentUser: UserModel, removeAll failureCompletion: @escaping (Error?) -> Void) {
    dataBase.collection("users/\(currentUser.email)/waitingChats").getDocuments { [weak self] snapshot, error in
      guard error == nil else { failureCompletion(error!); return }
      snapshot?.documents.forEach({ document in
        guard let chat = ChatModel(document: document) else { return }
        self?.waitingChat(deleteEverywhere: chat, by: currentUser, failureCompletion: failureCompletion)
      })
    }
  }
  
  // MARK: - Active chats
  /// Creates an active chat from waitingChat
  func activeChat(createBy chat: ChatModel, messages: [MessageModel], failureCompletion: @escaping (Error?) -> Void) {
    let messagesReference = activeChatsReference.document(chat.friend.email).collection("messages")
    activeChatsReference.document(chat.friend.email).setData(chat.representation) { error in
      if let error = error {
        failureCompletion(error)
        return
      }
      for message in messages {
        messagesReference.addDocument(data: message.representation) { addDocError in
          if let error = addDocError {
            failureCompletion(error)
            return
          }
          failureCompletion(nil)
        }
      }
    }
  }
  
  /// Provides a completion block with amount of active chats for certain user
  func activeChats(getAmountFor user: UserModel, completion: @escaping (Result<Int, Error>) -> Void) {
    let activeChatsReference = dataBase.collection("users/\(user.email)/activeChats")
    let activeChats = activeChatsReference
    activeChats.getDocuments { snapshot, error in
      guard let snapshot = snapshot else {
        completion(.failure(error!))
        return
      }
      let count = snapshot.documents.count
      completion(.success(count))
    }
  }
  
  /// Updates active chats for current user
  func activeChats(update completion: @escaping (Result<[ChatModel], Error>) -> Void) {
    guard let path = Auth.auth().currentUser?.email else { return }
    dataBase.collection("users/\(path)/activeChats").getDocuments { snapshot, error in
      guard let snapshot = snapshot else { completion(.failure(error!)); return }
      var activeChats = [ChatModel]()
      snapshot.documents.forEach { document in
        guard let chat = ChatModel(document: document) else { return }
        activeChats.append(chat)
      }
      completion(.success(activeChats.sorted()))
    }
  }
  
  /// Removes certain active chat from database (only for current user)
  func activeChat(delete chat: ChatModel, for currentUser: UserModel, failureCompletion: @escaping (Error?) -> Void) {
    let chatDocument = dataBase.collection("users/\(currentUser.email)/activeChats").document(chat.friend.email)
    chatDocument.delete { error in
      guard error == nil else { failureCompletion(error); return}
      
      let activeChatMessages = self.dataBase.collection("users/\(currentUser.email)/activeChats/\(chat.friend.email)/messages")
      activeChatMessages.getDocuments { snapshot, error in
        guard error == nil else { failureCompletion(error); return }
        snapshot?.documents.forEach({ document in
          let documentReference = activeChatMessages.document(document.documentID)
          documentReference.delete { failureCompletion($0) }
        })
      }
    }
  }
  
  /// Removes certain active chat for current user and corresponding friend's waiting chat from database
  func activeChat(deleteEverywhere chat: ChatModel, by currentUser: UserModel, failureCompletion: @escaping (Error?) -> Void) {
    let activeChat = dataBase.collection("users/\(currentUser.email)/activeChats").document(chat.friend.email)
    // delete active chat for  current user
    activeChat.delete { error in
      if let error { failureCompletion(error); return }
    }
    // delete messages
    let activeChatMessages = activeChat.collection("messages")
    activeChatMessages.getDocuments { snapshot, error in
      guard error == nil else { failureCompletion(error); return }
      snapshot?.documents.forEach({ document in
        let documentReference = activeChatMessages.document(document.documentID)
        documentReference.delete { error in
          if let error = error { failureCompletion(error); return }
        }
      })
    }
    // delete active chat for friend (if exists)
    let friendActiveChat = dataBase.collection("users/\(chat.friend.email)/activeChats").document(currentUser.email)
    friendActiveChat.getDocument { document, _ in
      guard let document else { return }
      friendActiveChat.delete { error in
        if let error { failureCompletion(error); return }
      }
      // delete messages
      let friendActiveChatMessages = friendActiveChat.collection("messages")
      friendActiveChatMessages.getDocuments { snapshot, error in
        guard error == nil else { failureCompletion(error); return }
        snapshot?.documents.forEach({ document in
          let documentReference = friendActiveChatMessages.document(document.documentID)
          documentReference.delete(completion: failureCompletion)
        })
      }
    }
    
    // delete waiting chat for friend (if exists)
    let friendWaitingChat = dataBase.collection("users/\(chat.friend.email)/waitingChats").document(currentUser.email)
    friendWaitingChat.getDocument { document, _ in
      guard let document else { return }
      friendActiveChat.delete { error in
        if let error { failureCompletion(error); return }
      }
      // delete messages
      let friendWaitingChatMessages = friendWaitingChat.collection("messages")
      friendWaitingChatMessages.getDocuments { snapshot, error in
        guard error == nil else { failureCompletion(error); return }
        snapshot?.documents.forEach({ document in
          let documentReference = friendWaitingChatMessages.document(document.documentID)
          documentReference.delete(completion: failureCompletion)
        })
      }
    }
  }
  
  /// Removes all active chats for user and friends waiting chats with user
  func activeChats(_ currentUser: UserModel, removeAll failureCompletion: @escaping (Error?) -> Void) {
    dataBase.collection("users/\(currentUser.email)/activeChats").getDocuments { [weak self] snapshot, error in
      guard error == nil else { failureCompletion(error!); return }
      snapshot?.documents.forEach({ document in
        guard let chat = ChatModel(document: document) else { return }
        self?.activeChat(deleteEverywhere: chat, by: currentUser, failureCompletion: failureCompletion)
      })
    }
  }
  
  /// Blocks certain active chat for current user
  func activeChat(_ chat: ChatModel, for currentUser: UserModel, block: Bool, failureCompletion: @escaping (Error?) -> Void) {
    let chatDocument = dataBase.collection("users/\(currentUser.email)/activeChats").document(chat.friend.email)
    chatDocument.updateData(["blocked": block], completion: failureCompletion)
  }
}

// MARK: - Messages
extension FirestoreService {
  /// Sends message to specified active chat
  func message(send message: MessageModel, by currentUser: UserModel, to activeChat: ChatModel, failureCompletion: @escaping (String?) -> Void) {
    let friendReference = dataBase.collection("users/\((activeChat.friend.email))/activeChats").document(currentUser.email)
    friendReference.getDocument { [weak self] document, error in
      if let error { failureCompletion(error.localizedDescription) }
      if let isBlocked = document?.data()?["blocked"] as? Bool, isBlocked {
        failureCompletion("User limited access to their private messages")
      } else {
        let friendMessageReference = friendReference.collection("messages").document(message.messageId)
        
        let myReference = self?.dataBase.collection("users/\(currentUser.email)/activeChats").document(activeChat.friend.email)
        let myMessageReference = myReference?.collection("messages").document(message.messageId)
        
        friendMessageReference.setData(message.representation, merge: true) { failureCompletion($0?.localizedDescription) }
        myMessageReference?.setData(message.representation, merge: true) { failureCompletion($0?.localizedDescription) }
      }
    }
  }
  
  /// Makes specified message 'read' for specified user
  func message(makeRead message: MessageModel, for friend: UserModel, failureCompletion: @escaping (Error?) -> Void) {
    let friendReference = dataBase.collection("users").document(friend.email).collection("activeChats").document(currentUser.email)
    let friendMessageReference = friendReference.collection("messages").document(message.messageId)
    
    let myReference = dataBase.collection("users").document(currentUser.email).collection("activeChats").document(friend.email)
    let myMessageReference = myReference.collection("messages").document(message.messageId)
    
    //    friendMessageReference.updateData(["read": true ]) { failureCompletion($0) }
    //    myMessageReference.updateData(["read": true ]) { failureCompletion($0) }
    friendMessageReference.setData(message.representation, merge: true) { failureCompletion($0) }
    myMessageReference.setData(message.representation, merge: true) { failureCompletion($0) }
  }
  
  /// Provides with last message in specified chat
  func message(getLastFrom chat: ChatModel, completion: @escaping (Result<MessageModel, Error>) -> Void) {
    let messagesReference = activeChatsReference.document(chat.friend.email).collection("messages")
    var messages = [MessageModel]()
    messagesReference.getDocuments { querySnapshot, error in
      guard let querySnapshot = querySnapshot else {
        completion(.failure(error!))
        return
      }
      
      for document in querySnapshot.documents {
        guard let message = MessageModel(document: document) else { return }
        messages.append(message)
      }
      messages.sort()
      guard let lastMessage = messages.last else { return }
      completion(.success(lastMessage))
    }
  }
}
