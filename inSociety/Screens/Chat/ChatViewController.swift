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
    configurator.cofigure(viewController: self)
    setupMessageListener()
    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    messageListener?.remove()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  private func setupMessageListener() {
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
  }
  
  private func insertNewMessage(message: MessageModel) {
    guard !messages.contains(message) else { return }
    messages.append(message)
    messages.sort()
    
    let isLastMessage = messages.firstIndex(of: message) == (messages.count - 1)
    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLastMessage
    if shouldScrollToBottom {
      DispatchQueue.main.async {
        self.messagesCollectionView.scrollToBottom()
      }
    }
    messagesCollectionView.reloadData()
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
    if isFromCurrentSender(message: message) {
      return .mainDark()
    } else {
      return .mainWhite()
    }
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
    return CGSize(width: 0, height: 10)
  }
  
  // Distance between messages(Need to do it between rare messages, for instance)
  func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    if indexPath.item == 0 {
      return 30
    }
    
    let distanceBetweenMessages = messages[indexPath.item - 1].sentDate.distance(to: messages[indexPath.item].sentDate)
    let requiredDistanceToDisplayDate = 3.0 * 60 * 60 // 3 hours
    
    if distanceBetweenMessages >= requiredDistanceToDisplayDate {
      return 20
    } else { return 0 }
  }
}

// MARK: - ConfigureMessageInputBar
extension ChatViewController {
  func setupViews() {
    title = chat.friendName
    
    if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
      layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
      layout.textMessageSizeCalculator.incomingAvatarSize = .zero
    }
    
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .mainDark()
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    messagesCollectionView.backgroundColor = .secondaryDark()
    messagesCollectionView.showsVerticalScrollIndicator = false
    messagesCollectionView.hideKeyboardWhenTappedOrSwiped()
    
    messageInputBar.isTranslucent = true
    messageInputBar.blurView.isHidden = true
    messageInputBar.separatorLine.isHidden = false
    messageInputBar.padding.bottom = 5
    messageInputBar.padding.top = 5
    messageInputBar.backgroundView.backgroundColor = .secondaryDark()
    messageInputBar.inputTextView.backgroundColor = .mainDark()
    messageInputBar.inputTextView.layer.cornerRadius = 20
    messageInputBar.inputTextView.layer.masksToBounds = true
    messageInputBar.inputTextView.placeholderLabel.font = .systemFont(ofSize: 12)
    messageInputBar.inputTextView.placeholder = "Сообщение"
    messageInputBar.inputTextView.font = .systemFont(ofSize: 14)
    messageInputBar.inputTextView.isImagePasteEnabled = false
    messageInputBar.inputTextView.autocorrectionType = .default
    messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
    messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
    
    configureSendButton()
  }
  
  func configureSendButton() {
    messageInputBar.sendButton.setImage(UIImage(named: "activeSendButton"), for: .normal)
    messageInputBar.sendButton.setImage(UIImage(named: "inactiveSendButton"), for: .disabled)
    messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    messageInputBar.sendButton.setSize(CGSize(width: 40, height: 40), animated: false)
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
    if indexPath.item == 0 {
      return displayDate(for: message)
    }
    
    let distanceBetweenMessages = messages[indexPath.item - 1].sentDate.distance(to: messages[indexPath.item].sentDate)
    let requiredDistanceToDisplayDate = 3.0 * 60 * 60 // 3 hours
    
    if distanceBetweenMessages >= requiredDistanceToDisplayDate {
      return displayDate(for: message)
    } else { return  nil }
  }
  
  private func displayDate(for message: MessageType) -> NSAttributedString {
    NSAttributedString(
      string: MessageKitDateFormatter.shared.string(from: message.sentDate),
      attributes: [
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
        NSAttributedString.Key.foregroundColor: UIColor.darkGray])
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
        self.messagesCollectionView.scrollToBottom(animated: true)
      case .failure(let error):
        self.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    }
    inputBar.inputTextView.text = ""
  }
}

// MARK: - ChatViewControllerProtocol
extension ChatViewController: ChatViewControllerProtocol {
  
}
