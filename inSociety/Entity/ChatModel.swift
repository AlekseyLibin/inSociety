//
//  ChatModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import FirebaseFirestore

final class ChatModel {
  var friend: UserModel
  var blocked: Bool = false
  var messages: [MessageModel]
  
  init(friend: UserModel, messages: [MessageModel]) {
    self.friend = friend
    self.messages = messages
  }
  
  init?(document: QueryDocumentSnapshot) {
    guard let friend = UserModel(document: document) else { return nil }
    let blocked = document.data()["blocked"] as? Bool ?? false
    
    self.friend = friend
    self.blocked = blocked
    self.messages = []
    fillUpMessages(by: document)
    return
  }
  
  private func fillUpMessages(by document: QueryDocumentSnapshot) {
    let messagesCollection = document.reference.collection("messages")
    messagesCollection.getDocuments { [weak self] snapshot, error in
      guard let snapshot = snapshot else { print(error!.localizedDescription); return }
      snapshot.documents.forEach { document in
        guard let message = MessageModel(document: document) else { return }
        self?.messages.append(message)
      }
    }
  }
  
  var representation: [String: Any] {
      let rep: [String: Any] = [
        "userAvatarString": friend.avatarString,
        "userName": friend.fullName,
        "userDescription": friend.description,
        "userEmail": friend.email,
        "userSex": friend.sex.rawValue,
        "userID": friend.id,
        "blocked": blocked
      ]
      return rep
  }
  
  func contains(filter: String?) -> Bool {
    guard let filter = filter, filter.isEmpty == false else { return true }
    
    let lowercasedFilter = filter.lowercased()
    return friend.fullName.lowercased().contains(lowercasedFilter)
  }
}

// MARK: - Hashable
extension ChatModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(friend.id)
  }
  
  static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
    guard lhs.friend.id == rhs.friend.id,
          lhs.friend.fullName == rhs.friend.fullName,
          lhs.friend.avatarString == rhs.friend.avatarString,
          lhs.blocked == rhs.blocked,
          lhs.messages.sorted() == rhs.messages.sorted() else { return false }
    return true
  }
}

// MARK: - Comparable
extension ChatModel: Comparable {
    static func < (lhs: ChatModel, rhs: ChatModel) -> Bool {
      if let lhsSentDate = lhs.messages.sorted().last?.sentDate,
         let rhsSentDate = rhs.messages.sorted().last?.sentDate {
        return lhsSentDate > rhsSentDate
      } else { return true }
    }
    
}
