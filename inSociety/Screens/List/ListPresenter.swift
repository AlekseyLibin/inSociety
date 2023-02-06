//
//  ListPresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 04.02.2023.
//

import Foundation
import FirebaseFirestore

protocol ListPresenterProtocol: AnyObject {
  func setupListeners( _ waitingChatsListener: inout ListenerRegistration?, _ activeChatsListener: inout ListenerRegistration?)
  func updateLastMessage()
  func waitingChat(moveToActive chat: ChatModel)
  func waitingChat(remove chat: ChatModel)
  func navigate(toChatRequestVC chat: ChatModel)
  func navigate(toChatVC currentUser: UserModel, chat: ChatModel)
}

final class ListPresenter {
  
  init(viewController: ListViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ListViewControllerProtocol
  var interactor: ListInteractorProtocol!
  var router: ListRouterProtocol!
}

extension ListPresenter: ListPresenterProtocol {
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
        self.viewController.showAlert(with: "Success", and: "Chat request has been denied")
      case .failure(let error):
        self.viewController.showAlert(with: "Error", and: error.localizedDescription)
      }
    }
  }
  
  func waitingChat(moveToActive chat: ChatModel) {
    interactor.waitingChat(moveToActive: chat) { result in
      switch result {
      case .success():
        break
      case .failure(let error):
        self.viewController.showAlert(with: "Error", and: error.localizedDescription)
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
          self.viewController.showAlert(with: "Error", and: error.localizedDescription)
        }
      }
    }
  }
  
  
  func setupListeners(_ waitingChatsListener: inout ListenerRegistration?, _ activeChatsListener: inout ListenerRegistration?) {
    
    var waitingChats: [ChatModel] {
      return viewController.waitingChats
    }
    var activeChats: [ChatModel] {
      return viewController.activeChats
    }
    
    waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { difference in
      switch difference {
      case .success(let updatedWaitingChats):
        if updatedWaitingChats.count > waitingChats.count {
          self.router.toChatRequestVC(chat: updatedWaitingChats.last!)
        }
        self.viewController.changeValueFor(waitingChats: updatedWaitingChats)
      case .failure(let error):
        self.viewController.showAlert(with: "Error", and: error.localizedDescription)
      }
    })
    
    activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { difference in
      
      switch difference {
      case .success(let updatedActiveChats):
        self.viewController.changeValueFor(activeChats: updatedActiveChats)
      case .failure(let error):
        self.viewController.showAlert(with: "Error", and: error.localizedDescription)
      }
    })
  }
  
  
}
