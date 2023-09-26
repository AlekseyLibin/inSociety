//
//  ChatsPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 04.02.2023.
//

import Foundation
import FirebaseFirestore

protocol ChatsPresenterProtocol: AnyObject {
  func setupListeners( _ waitingChatsListener: inout ListenerRegistration?, _ activeChatsListener: inout ListenerRegistration?)
  func updateActiveChats(completion: @escaping (Result<[ChatModel], Error>) -> Void)
  func waitingChat(moveToActive chat: ChatModel)
  func waitingChat(remove chat: ChatModel)
  func navigate(toChatRequestVC chat: ChatModel)
  func navigate(toChatVC currentUser: UserModel, chat: ChatModel)
}

final class ChatsPresenter {
  
  init(viewController: ChatsViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ChatsViewControllerProtocol
  var interactor: ChatsInteractorProtocol!
  var router: ChatsRouterProtocol!
}

extension ChatsPresenter: ChatsPresenterProtocol {
  func navigate(toChatRequestVC chat: ChatModel) {
    router.toChatRequestVC(chat: chat)
  }
  
  func navigate(toChatVC currentUser: UserModel, chat: ChatModel) {
    router.toChatVC(currentUser: currentUser, chat: chat)
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
        self?.viewController.updateActiveChats()
        self?.viewController.generateHapticFeedback(.success)
      }
    }
  }
  
  func updateActiveChats(completion: @escaping (Result<[ChatModel], Error>) -> Void) {
    interactor.updateActiveChats(completion: completion)
  }
  
  func setupListeners(_ waitingChatsListener: inout ListenerRegistration?, _ activeChatsListener: inout ListenerRegistration?) {
    var waitingChats: [ChatModel] {
      get {
        return viewController.waitingChats
      } set {
        viewController.emptyWaitingChatsLabel(isActive: newValue.isEmpty)
      }
    }
    var activeChats: [ChatModel] {
      get {
        return viewController.activeChats
      } set {
        viewController.emptyActiveChatsLabel(isActive: newValue.isEmpty)
      }
    }
    
    waitingChatsListener = ListenerService.shared.waitingChats(observe: waitingChats, { difference in
      switch difference {
      case .success(let updatedWaitingChats):
        self.viewController.changeValueFor(waitingChats: updatedWaitingChats)
      case .failure(let error):
        self.viewController.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    })
    
    activeChatsListener = ListenerService.shared.activeChats(observe: activeChats, { difference in
      switch difference {
      case .success(let updatedActiveChats):
        self.viewController.changeValueFor(activeChats: updatedActiveChats)
      case .failure(let error):
        self.viewController.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    })
  }
  
}
