//
//  UserNearbyModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import FirebaseFirestore

struct UserModel: Hashable, Decodable {
    var userName: String
    var userAvatarString: String
    var email: String
    var description: String
    var sex: String
    var id: String
    
    init(userName: String, userAvatarString: String, email: String, description: String, sex: String, id: String) {
        
        self.userName = userName
        self.userAvatarString = userAvatarString
        self.email = email
        self.description = description
        self.sex = sex
        self.id = id
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let userName = data["userName"] as? String,
              let userAvatarString = data["userAvatarString"] as? String,
              let email = data["email"] as? String,
              let description = data["description"] as? String,
              let sex = data["sex"] as? String,
              let id = data["uid"] as? String
        else { return nil }
        
        self.userName = userName
        self.userAvatarString = userAvatarString
        self.email = email
        self.description = description
        self.sex = sex
        self.id = id
    }
    
    init?(queryDocument: QueryDocumentSnapshot) {
        let data = queryDocument.data()
        guard let userName = data["userName"] as? String,
              let userAvatarString = data["userAvatarString"] as? String,
              let email = data["email"] as? String,
              let description = data["description"] as? String,
              let sex = data["sex"] as? String,
              let id = data["uid"] as? String
        else { return nil }
        
        self.userName = userName
        self.userAvatarString = userAvatarString
        self.email = email
        self.description = description
        self.sex = sex
        self.id = id
    }
    
    var representationDict: [String: Any] {
        var rep = ["userName": userName]
        rep["userAvatarString"] = userAvatarString
        rep["email"] = email
        rep["description"] = description
        rep["sex"] = sex
        rep["uid"] = id
        return rep
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter, filter.isEmpty == false else { return true }
        
        let lowercasedFilter = filter.lowercased()
        return userName.lowercased().contains(lowercasedFilter)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
}
