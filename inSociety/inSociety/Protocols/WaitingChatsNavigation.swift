//
//  WaitingChatsNavigation.swift
//  inSociety
//
//  Created by Aleksey Libin on 26.10.2022.
//

import Foundation

protocol WaitingChatsNavigation: AnyObject {
    func removeWaitingChat(chat: ChatModel)
    func moveToActive(chat: ChatModel)
}
