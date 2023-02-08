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
    private init() {}

    private let dataBase = Firestore.firestore()
    var currentUserModel: UserModel!

    
    private var usersReference: CollectionReference {
        return dataBase.collection("users")
    }
    
    private var waitingChatsReference: CollectionReference {
        return dataBase.collection("users/\(currentUserModel.id)/waitingChats")
    }
    
    private var activeChatsReference: CollectionReference {
        return dataBase.collection("users/\(currentUserModel.id)/activeChats")
    }
    
}


//MARK: - User
extension FirestoreService {
    
    func getDataForCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(UserError.cannotGetUserInfo))
            return
        }
        
        let documentReference = usersReference.document(currentUser.uid)
        documentReference.getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                guard let user = UserModel(document: document) else {
                    completion(.failure(UserError.cannotUnwrapFBDataToUserModel))
                    return
                }
                self.currentUserModel = user
                completion(.success(user))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfile(with newUser: SetupNewUser, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        guard
            let userName = newUser.name,
            let avatarImage = newUser.avatarImage,
            let description = newUser.desctiption,
            let sex = newUser.sex,
            !userName.isEmpty,
            !description.isEmpty,
            !sex.isEmpty
        else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != UIImage(named: "ProfilePhoto") else {
            completion(.failure(UserError.noPhoto))
            return
        }
        
        var userModel = UserModel(userName: userName,
                                  userAvatarString: "not exist",
                                  email: newUser.email,
                                  description: description,
                                  sex: sex,
                                  id: newUser.id)
        StorageService.shared.upload(image: avatarImage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let avatatarURL):
                userModel.userAvatarString = avatatarURL.absoluteString
                self.usersReference.document(userModel.id).setData(userModel.representationDict) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(userModel))
                        self.currentUserModel = userModel
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}


//MARK: - Chats
extension FirestoreService {
    
    func checkNoChats(with friend: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let activeChatMessages = activeChatsReference.document(friend.id).collection("messages")
        activeChatMessages.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            
            if snapshot.documents.isEmpty {
                let waitingChatMessages = self.waitingChatsReference.document(friend.id).collection("messages")
                waitingChatMessages.getDocuments { snapshot, error in
                    guard let snapshot = snapshot else {
                        completion(.failure(error!))
                        return
                    }
                    
                    if snapshot.documents.isEmpty {
                        completion(.success(Void()))
                    } else {
                        completion(.failure(UserError.chatAlreadyExists))
                    }
                }
            } else {
                completion(.failure(UserError.chatAlreadyExists))
            }
        }
    }
    
    //MARK: - Waiting chats
    func createWaitingChat(message: String, receiver: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let waitingChatsReference = dataBase.collection("users/\(receiver.id)/waitingChats")
        
        let messageReference = waitingChatsReference.document(currentUserModel.id).collection("messages")

        let message = MessageModel(user: currentUserModel, content: message)
        let chat = ChatModel(friendName: currentUserModel.userName,
                             friendAvatarString: currentUserModel.userAvatarString,
                             lastMessageContent: message.content,
                             friendID: currentUserModel.id)
        waitingChatsReference.document(currentUserModel.id).setData(chat.representation) { error in
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
        waitingChatsReference.document(chat.friendID).delete { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func getNumberOfWaitingChats(for user: UserModel, completion: @escaping(Result<Int, Error>) -> Void) {
        let waitingChatsReference = dataBase.collection("users/\(user.id)/waitingChats")
        waitingChatsReference.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            
            let count = snapshot.documents.count
            completion(.success(count))
        }
    }
    
    func moveWaitingChatToActive(chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { result in
                    switch result {
                    case .success:
                        self.createActiveChat(chat: chat, messages: messages) { result in
                            switch result {
                            case .success:
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: Active chats
    func createActiveChat(chat: ChatModel, messages: [MessageModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let messageReference = activeChatsReference.document(chat.friendID).collection("messages")
        activeChatsReference.document(chat.friendID).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for message in messages {
                messageReference.addDocument(data: message.representation) { erorr in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    func getNumberOfActiveChats(for user: UserModel, completion: @escaping (Result<Int, Error>) -> Void) {
        let activeChatsReference = dataBase.collection("users/\(user.id)/activeChats")
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
    
}


//MARK: - Messages
extension FirestoreService {
    func sendMessage(chat: ChatModel, message: MessageModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendReference = usersReference.document(chat.friendID).collection("activeChats").document(currentUserModel.id)
        let friendMessageReference = friendReference.collection("messages")
        let myMessageReference = usersReference.document(currentUserModel.id).collection("activeChats").document(chat.friendID).collection("messages")
        
        let chatForFriend = ChatModel(friendName: currentUserModel.userName,
                                      friendAvatarString: currentUserModel.userAvatarString,
                                      lastMessageContent: message.content,
                                      friendID: currentUserModel.id)
        friendReference.setData(chatForFriend.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessageReference.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessageReference.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
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
    
    func getLastMessage(chat: ChatModel, completion: @escaping (Result<MessageModel, Error>) -> Void) {
        let messagesReference = activeChatsReference.document(chat.friendID).collection("messages")
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
    
    func getWaitingChatMessages(chat: ChatModel, completion: @escaping (Result<[MessageModel], Error>) -> Void) {
        let messagesReference = waitingChatsReference.document(chat.friendID).collection("messages")
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
}
