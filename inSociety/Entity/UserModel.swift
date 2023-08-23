//
//  UserNearbyModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import FirebaseFirestore

struct UserModel: Hashable, Decodable {
  
  enum Sex: String, Decodable, CaseIterable {
    case male
    case female
    case other
    
    init(by string: String) {
      switch string.lowercased() {
      case "male": self = .male
      case "female": self = .female
      default: self = .other
      }
    }
    
    init(by int: Int) {
      switch int {
      case 0: self = .male
      case 1: self = .female
      default: self = .other
      }
    }
    
    var localized: String {
      NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
    }
  }
  
  var fullName: String
  var avatarString: String
  var email: String
  var description: String
  var sex: Sex
  var id: String
  
  init(userName: String, userAvatarString: String, email: String, description: String, sex: Sex, id: String) {
    
    self.fullName = userName
    self.avatarString = userAvatarString
    self.email = email
    self.description = description
    self.sex = sex
    self.id = id
  }
  
  init?(document: DocumentSnapshot) {
    guard let data = document.data(),
          let userName = data["userName"] as? String,
          let userAvatarString = data["userAvatarString"] as? String,
          let email = data["email"] as? String,
          let description = data["description"] as? String,
          let sexString = data["sex"] as? String,
          let id = data["uid"] as? String
    else { return nil }
    
    self.fullName = userName
    self.avatarString = userAvatarString
    self.email = email
    self.description = description
    self.id = id
    self.sex = Sex(by: sexString)
  }
  
  init?(queryDocument: QueryDocumentSnapshot) {
    let data = queryDocument.data()
    guard let userName = data["userName"] as? String,
          let userAvatarString = data["userAvatarString"] as? String,
          let email = data["email"] as? String,
          let description = data["description"] as? String,
          let sexString = data["sex"] as? String, let sex = Sex(rawValue: sexString.lowercased()),
          let id = data["uid"] as? String
    else { return nil }
    
    self.fullName = userName
    self.avatarString = userAvatarString
    self.email = email
    self.description = description
    self.id = id
    self.sex = sex
  }
  
  var representationDict: [String: Any] {
    var rep = ["userName": fullName]
    rep["userAvatarString"] = avatarString
    rep["email"] = email
    rep["description"] = description
    rep["sex"] = sex.rawValue
    rep["uid"] = id
    return rep
  }
  
  func contains(filter: String?) -> Bool {
    guard let filter = filter, filter.isEmpty == false else { return true }
    
    let lowercasedFilter = filter.lowercased()
    return fullName.lowercased().contains(lowercasedFilter)
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: UserModel, rhs: UserModel) -> Bool {
    return lhs.id == rhs.id
  }
}
