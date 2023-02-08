//
//  ListRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 04.02.2023.
//

import Foundation

protocol ListRouterProtocol: AnyObject {
  func toChatRequestVC(chat: ChatModel)
  func toChatVC(currentUser:  UserModel, chat: ChatModel)
}

final class ListRouter {
  
  init(viewController: ListViewController) {
    self.viewController = viewController
  }
  
  private unowned let viewController: ListViewController
}

extension ListRouter: ListRouterProtocol {
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
