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
    
    private var waitingChatsReference: CollectionReference {
        return db.collection("users/\(currentUser.id)/waitingChats")
    }
    
    var currentUser: UserModel!

    
    func getUserData(user: User, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
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
                        self.currentUser = userModel
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func createWaitingChat(message: String, receiver: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let waitingChatsReference = db.collection("users/\(receiver.id)/waitingChats")
        
        let messageReference = waitingChatsReference.document(currentUser.id).collection("messages")

        let message = MessageModel(user: currentUser, content: message)
        let chat = ChatModel(friendName: currentUser.userName,
                             friendAvatarString: currentUser.userAvatarString,
                             lastMessageContent: message.content,
                             friendID: currentUser.id)
        waitingChatsReference.document(currentUser.id).setData(chat.representation) { error in
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
    
    
    func deleteWaitingChat(chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatsReference.document(chat.friendID).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func getWaitingChatMessages(chat: ChatModel, completion: @escaping (Result<[MessageModel], Error>) -> Void) {
        let messagesReference = waitingChatsReference.document(chat.friendID).collection("messages")
        var messages = [MessageModel]()
        messagesReference.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for document in querySnapshot!.documents {
                guard let message = MessageModel(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    func deleteMessages(chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let messagesReference = waitingChatsReference.document(chat.friendID).collection("messages")
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentID = message.id else { return }
                    let messageReference = messagesReference.document(documentID)
                    messageReference.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
