//
//  FirestoreService.swift
//  inSociety
//
//  Created by Aleksey Libin on 21.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    func getUserData(user: User, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let user = UserModel(document: document) else {
                    completion(.failure(UserError.cannotUnwrapFBDataToUserModel))
                    return
                }
                completion(.success(user))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(userName: String?,
                         avatarImage: UIImage?,
                         email: String,
                         description: String?,
                         sex: String?,
                         id: String,
                         completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        guard Validator.isFilled(userName: userName, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != UIImage(named: "ProfilePhoto") else {
            completion(.failure(UserError.noPhoto))
            return
        }
        
        
        var userModel = UserModel(userName: userName!,
                                  userAvatarString: "not exist",
                                  email: email,
                                  description: description!,
                                  sex: sex!,
                                  id: id)
        StorageService.shared.upload(image: avatarImage!) { result in
            switch result {
            case .success(let avatatarURL):
                userModel.userAvatarString = avatatarURL.absoluteString
                self.usersRef.document(userModel.id).setData(userModel.representationDict) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(userModel))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
