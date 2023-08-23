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
  func updateLastMessage()
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
  
  func updateLastMessage() {
    for index in 0 ..< viewController.activeChats.count {
      interactor.getLastMessage(chat: viewController.activeChats[index]) { result in

        switch result {
        case .success(let message):
          self.viewController.collectionView(updateCellValueBy: [1, index], with: message.content)
        case .failure(let error):
          self.viewController.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
        }
      }
    }
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
    
    waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { difference in
      switch difference {
      case .success(let updatedWaitingChats):
        self.viewController.changeValueFor(waitingChats: updatedWaitingChats)
      case .failure(let error):
        self.viewController.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    })
    
    activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { difference in
      
      switch difference {
      case .success(let updatedActiveChats):
        self.viewController.changeValueFor(activeChats: updatedActiveChats)
      case .failure(let error):
        self.viewController.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    })
  }
  
}
