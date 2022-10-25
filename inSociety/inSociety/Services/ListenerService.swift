//
//  ListenerService.swift
//  inSociety
//
//  Created by Aleksey Libin on 25.10.2022.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    
    func usersObserve(users: [UserModel], completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration? {
        
        var allUsers = users
        let usersListener = usersRef.addSnapshotListener { querySnapshot, error in
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
}
