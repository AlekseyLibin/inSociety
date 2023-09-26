//
//  PeopleRouter.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.02.2023.
//

import UIKit

protocol PeopleRouterProtocol: AnyObject {
  func toSendRequestVC(to user: UserModel, by currentUser: UserModel, delegate: SendRequestPresenterDelegate?)
  func toChatVC(with user: UserModel)
  func toChatRequestVC(with chat: ChatModel)
}

final class PeopleRouter {
  
  init(viewController: PeopleViewControllerProtocol) {
    self.viewController = viewController
  }
  
  private unowned let viewController: PeopleViewControllerProtocol
  
}

extension PeopleRouter: PeopleRouterProtocol {
  func toChatRequestVC(with chat: ChatModel) {
    let chatRequestVC = ChatRequestViewController(chat: chat)
    chatRequestVC.delegate = viewController
    viewController.present(chatRequestVC, animated: true, completion: nil)
  }
  
  func toSendRequestVC(to user: UserModel, by currentUser: UserModel, delegate: SendRequestPresenterDelegate?) {
    let sendRequestVC = SendRequestViewController(to: user, by: currentUser)
    sendRequestVC.presenter.delegate = delegate
    viewController.present(sendRequestVC, animated: true, completion: nil)
  }
  
  func toChatVC(with user: UserModel) {
    if let tabBarController = viewController.tabBarController,
       let navigationController = tabBarController.viewControllers?[1] as? UINavigationController,
       let chatsViewController = navigationController.viewControllers.first as? ChatsViewControllerProtocol,
       let chat = chatsViewController.activeChats.filter({ $0.friend.id == user.id }).first {
      let chatVC = ChatViewController(currentUser: viewController.currentUser, chat: chat)
      chatVC.hidesBottomBarWhenPushed = true
      viewController.navigationController?.pushViewController(chatVC, animated: true)
    }
  }
}
