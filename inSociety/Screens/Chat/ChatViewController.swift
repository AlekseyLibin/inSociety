//
//  ChatViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 28.10.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

protocol ChatViewControllerProtocol: AnyObject {
  
}

final class ChatViewController: MessagesViewController {
  
  private var messages: [MessageModel] = []
  private var messageListener: ListenerRegistration?
  
  private let currentUser: UserModel
  private var chat: ChatModel
  private let configurator: ChatConfiguratorProtocol = ChatConfigurator()
  var presenter: ChatPresenterProtocol!
  
  init(currentUser: UserModel, chat: ChatModel) {
    self.currentUser = currentUser
    self.chat = chat
    super.init(nibName: nil, bundle: nil)
    
    title = chat.friendName
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    messageListener?.remove()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurator.cofigure(viewController: self)
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.mainYellow()]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
    
    messageListener = presenter.messagesListener(by: chat) { [weak self] result in
      guard let self = self else { return}
      
      switch result {
      case .success(let message):
        self.chat.lastMessageContent = message.content
        self.insertNewMessage(message: message)
      case .failure(let error):
        self.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    }
    
    configureMessageInputBar()
    messagesCollectionView.backgroundColor = .mainDark()
    
    if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
      layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
      layout.textMessageSizeCalculator.incomingAvatarSize = .zero
    }
    
    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    
  }
  
  private func insertNewMessage(message: MessageModel) {
    guard !messages.contains(message) else { return }
    messages.append(message)
    messages.sort()
    
    let isLastMessage = messages.firstIndex(of: message) == (messages.count - 1)
    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLastMessage
    
    messagesCollectionView.reloadData()
    
    if shouldScrollToBottom {
      DispatchQueue.main.async {
        self.messagesCollectionView.scrollToLastItem(animated: true)
      }
    }
  }
  
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    if isFromCurrentSender(message: message) {
      return .currentUserMessage()
    } else {
      return .friendMessage()
    }
  }
  
  func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return .white
  }
  
  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    avatarView.isHidden = true
  }
  
  func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
    return .zero
  }
  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    return .bubble
  }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
  
  // Distance between last message and text field
  func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
  }
  
  // Distance between messages(Need to do it between rare messages, for instance)
  func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 30
  }
}

// MARK: - ConfigureMessageInputBar
extension ChatViewController {
  func configureMessageInputBar() {
    
    messageInputBar.isTranslucent = true
    messageInputBar.separatorLine.isHidden = true
    messageInputBar.backgroundView.backgroundColor = .secondaryDark()
    messageInputBar.inputTextView.backgroundColor = .secondaryDark()
    messageInputBar.inputTextView.placeholderTextColor = .mainWhite()
    messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
    messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
    messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
    messageInputBar.inputTextView.layer.borderWidth = 0.2
    messageInputBar.inputTextView.layer.cornerRadius = 18.0
    messageInputBar.inputTextView.layer.masksToBounds = true
    messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
    
    messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    messageInputBar.layer.shadowRadius = 5
    messageInputBar.layer.shadowOpacity = 0.3
    messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
    
    configureSendButton()
  }
  
  func configureSendButton() {
    messageInputBar.sendButton.setImage(UIImage(named: "Send"), for: .normal)
    messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
    messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
    messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
    messageInputBar.middleContentViewPadding.right = -38
  }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
  func currentSender() -> MessageKit.SenderType {
    Sender(senderID: currentUser.id, senderName: currentUser.fullName)
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
    return messages[indexPath.item]
  }
  
  func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
    messages.count
  }
  
  func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
    return 1
  }
  
  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    if indexPath.item % 5 == 0 {
      return NSAttributedString(
        string: MessageKitDateFormatter.shared.string(from: message.sentDate),
        attributes: [
          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
          NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    } else { return nil }
  }
  
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    let message = MessageModel(user: currentUser, content: text)
    FirestoreService.shared.sendMessage(chat: chat, message: message) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        self.messagesCollectionView.scrollToLastItem()
      case .failure(let error):
        self.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    }
    inputBar.inputTextView.text = ""
  }
}

extension ChatViewController: ChatViewControllerProtocol {
  
}
