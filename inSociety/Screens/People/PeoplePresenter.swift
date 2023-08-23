//
//  PeoplePresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.02.2023.
//

import Foundation
import FirebaseFirestore

protocol PeoplePresenterProtocol: AnyObject {
  func usersObserve(users: [UserModel], completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration?
  func friendSelected(_ userModel: UserModel)
  func waitingChat(moveToActive chat: ChatModel)
  func waitingChat(remove chat: ChatModel)
}

final class PeoplePresenter {
  
  init(viewController: PeopleViewControllerProtocol) {
    self.viewController = viewController
    setupChatsListeners()
  }
  
  private unowned let viewController: PeopleViewControllerProtocol
  var interactor: PeopleInteractorProtocol!
  var router: PeopleRouterProtocol!
  
  private var waitingChatsListener: ListenerRegistration?
  private var activeChatsListener: ListenerRegistration?
  private var waitingChats = [ChatModel]()
  private var activeChats = [ChatModel]()
  private var users = [UserModel]()
  
  func setupChatsListeners() {
    
    waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { [weak self] difference in
      switch difference {
      case .success(let updatedWaitingChats):
        self?.waitingChats = updatedWaitingChats
      case .failure(let error):
        self?.viewController.showAlert(with: PeopleString.error.localized, and: error.localizedDescription)
      }
    })
    
    activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { [weak self] difference in
      switch difference {
      case .success(let updatedActiveChats):
        self?.activeChats = updatedActiveChats
      case .failure(let error):
        self?.viewController.showAlert(with: PeopleString.error.localized, and: error.localizedDescription)
      }
    })
  }
}

extension PeoplePresenter: PeoplePresenterProtocol {
  func friendSelected(_ userModel: UserModel) {
    if let waitingChat = waitingChats.filter({ $0.friendID == userModel.id }).first {
      router.toChatRequestVC(with: waitingChat)
    } else if let _ = activeChats.filter({ $0.friendID == userModel.id }).first {
      router.toChatVC(with: userModel)
    } else {
      router.toSendRequestVC(with: userModel, delegate: self)
    }
  }
  
  func usersObserve(users: [UserModel], completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration? {
    interactor.usersObserve(users: users, completion: completion)
  }
  
  func waitingChat(remove chat: ChatModel) {
    interactor.waitingChat(remove: chat) { result in
      switch result {
      case .success:
        self.viewController.showAlert(with: ChatsString.success.localized, and: ChatsString.chatRequestDenied.localized)
      case .failure(let error):
        self.viewController.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    }
  }
  
  func waitingChat(moveToActive chat: ChatModel) {
    interactor.waitingChat(moveToActive: chat) { result in
      switch result {
      case .success:
        break
      case .failure(let error):
        self.viewController.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    }
  }
}

// MARK: - SendRequestPresenterDelegate
extension PeoplePresenter: SendRequestPresenterDelegate {
  func requestSentSuccessfully() {
    viewController.playSuccessAnimation()
  }
  
  func requestHasNotBeenSent(with error: Error) {
    viewController.showAlert(with: PeopleString.error.localized, and: error.localizedDescription)
  }
  
}
