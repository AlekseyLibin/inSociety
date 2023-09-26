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
  func friendSelected(_ userModel: UserModel, by currentUser: UserModel)
  func waitingChat(moveToActive chat: ChatModel)
  func waitingChat(remove chat: ChatModel)
}

final class PeoplePresenter {
  
  init(viewController: PeopleViewControllerProtocol) {
    self.viewController = viewController
    setupChatsListeners()
  }
  
  deinit {
    activeChatsListener?.remove()
    waitingChatsListener?.remove()
  }
  
  private unowned let viewController: PeopleViewControllerProtocol
  var interactor: PeopleInteractorProtocol!
  var router: PeopleRouterProtocol!
  
  private var waitingChatsListener: ListenerRegistration?
  private var activeChatsListener: ListenerRegistration?
  private var waitingChats = [ChatModel]()
  private var activeChats = [ChatModel]()
  private var users = [UserModel]()
  
  private func setupChatsListeners() {
    waitingChatsListener = ListenerService.shared.waitingChats(observe: waitingChats, { [weak self] difference in
      switch difference {
      case .success(let updatedWaitingChats):
        self?.waitingChats = updatedWaitingChats
      case .failure(let error):
        self?.viewController.showAlert(with: PeopleString.error.localized, and: error.localizedDescription)
      }
    })
    
    activeChatsListener = ListenerService.shared.activeChats(observe: activeChats, { [weak self] difference in
      switch difference {
      case .success(let updatedActiveChats):
        self?.activeChats = updatedActiveChats
      case .failure(let error):
        self?.viewController.showAlert(with: PeopleString.error.localized, and: error.localizedDescription)
      }
    })
  }
  
  private func suggestToUnblock(_ chat: ChatModel) {
    let alertController = UIAlertController(title: "\(chat.friend.fullName) \(PeopleString.isBlocked)", message: "\(PeopleString.doYouWantToUnblock.localized) \(chat.friend.fullName)?", preferredStyle: .alert)
    let unblock = UIAlertAction(title: PeopleString.unblock.localized, style: .default) { [weak self] _ in
      guard let currentUser = self?.viewController.currentUser else { return }
      self?.interactor.activeChat(chat, for: currentUser, block: false, failureCompletion: { error in
        if let error { self?.viewController.showAlert(with: PeopleString.error.localized, and: error.localizedDescription) }
        self?.router.toChatVC(with: chat.friend)
      })
    }
    let cancel = UIAlertAction(title: PeopleString.cancel.localized, style: .default)
    cancel.setValue(UIColor.white, forKey: "titleTextColor")
    
    alertController.addAction(cancel)
    alertController.addAction(unblock)
    viewController.present(alertController, animated: true, completion: nil)
  }
  
}

extension PeoplePresenter: PeoplePresenterProtocol {
  func friendSelected(_ userModel: UserModel, by currentUser: UserModel) {
    if let waitingChat = waitingChats.filter({ $0.friend.id == userModel.id }).first {
      router.toChatRequestVC(with: waitingChat)
    } else if let activeChat = activeChats.filter({ $0.friend.id == userModel.id }).first {
      activeChat.blocked ? suggestToUnblock(activeChat) : router.toChatVC(with: userModel)
    } else {
      router.toSendRequestVC(to: userModel, by: currentUser, delegate: self)
    }
  }
  
  func usersObserve(users: [UserModel], completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration? {
    interactor.usersObserve(users: users, completion: completion)
  }
  
  func waitingChat(remove chat: ChatModel) {
    interactor.waitingChat(remove: chat) { [weak self] error in
      if let error = error {
        self?.viewController.generateHapticFeedback(.error)
        self?.viewController.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      } else {
        self?.viewController.generateHapticFeedback(.warning)
      }
    }
  }
  
  func waitingChat(moveToActive chat: ChatModel) {
    interactor.waitingChat(moveToActive: chat) { [weak self] error in
      if let error = error {
        self?.viewController.generateHapticFeedback(.error)
        self?.viewController.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      } else {
        self?.viewController.generateHapticFeedback(.success)
      }
    }
  }
}

// MARK: - SendRequestPresenterDelegate
extension PeoplePresenter: SendRequestPresenterDelegate {
  func requestSentSuccessfully() {
    viewController.playSuccessAnimation()
    viewController.generateHapticFeedback(.success)
  }
  
  func requestHasNotBeenSent(with error: Error) {
    viewController.generateHapticFeedback(.error)
    viewController.showAlert(with: PeopleString.error.localized, and: error.localizedDescription)
  }
  
}
