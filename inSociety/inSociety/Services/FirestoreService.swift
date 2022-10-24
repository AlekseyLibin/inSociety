//
//  FirestoreService.swift
//  inSociety
//
//  Created by Aleksey Libin on 21.10.2022.
//

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
                         avatarImageString: String?,
                         email: String,
                         description: String?,
                         sex: String?,
                         id: String,
                         completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        guard Validator.isFilled(userName: userName, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        
        let userModel = UserModel(userName: userName!,
                                  userAvatarString: "not exist",
                                  email: email,
                                  description: description!,
                                  sex: sex!,
                                  id: id)
        self.usersRef.document(userModel.id).setData(userModel.representationDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(userModel))
            }
        }
    }
}
