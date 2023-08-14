//
//  ChatsRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 04.02.2023.
//

import Foundation

protocol ChatsRouterProtocol: AnyObject {
  func toChatRequestVC(chat: ChatModel)
  func toChatVC(currentUser:  UserModel, chat: ChatModel)
}

final class ChatsRouter {
  
  init(viewController: ChatsViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ChatsViewController
}

extension ChatsRouter: ChatsRouterProtocol {
  func toChatVC(currentUser: UserModel, chat: ChatModel) {
    let chatVC = ChatViewController(currentUser: currentUser, chat: chat)
    chatVC.hidesBottomBarWhenPushed = true
    viewController.navigationController?.pushViewController(chatVC, animated: true)
  }
  
  func toChatRequestVC(chat: ChatModel) {
    
    let chatRequestVC = ChatRequestViewController(chat: chat)
    chatRequestVC.delegate = viewController
    viewController.present(chatRequestVC, animated: true)
    
  }
  
}
