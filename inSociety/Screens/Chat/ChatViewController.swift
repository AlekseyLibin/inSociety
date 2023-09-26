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
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
  var navigationController: UINavigationController? { get }
}

final class ChatViewController: MessagesViewController {
  
  private var messagesListener: ListenerRegistration?
  
  private let currentUser: UserModel
  private var chat: ChatModel
  private let configurator: ChatConfiguratorProtocol = ChatConfigurator()
  var presenter: ChatPresenterProtocol!
  
  init(currentUser: UserModel, chat: ChatModel) {
    self.currentUser = currentUser
    self.chat = chat
    self.chat.messages.sort()
    super.init(nibName: nil, bundle: nil)
    configurator.cofigure(viewController: self)
    setupMessagesListener()
    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    messagesListener?.remove()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    messagesCollectionView.scrollToBottom()
  }
  
  private func setupMessagesListener() {
    messagesListener = presenter.messagesListener(for: chat, observe: { [weak self] result in
      switch result {
      case .success(let updatedMessageStatus):
        switch updatedMessageStatus {
        case .added(let newMessage):
          self?.message(new: newMessage)
        case .modified(let modifiedMessage):
          break //  TODO: modified
        case .removed:
          break // TODO: removed
        }
        
      case .failure(let error):
        self?.showAlert(with: ChatsString.error.localized, and: error.localizedDescription)
      }
    })
  }
  
  //  private func insertNewMessage(message: MessageModel) {
  //    if chat.messages.contains(message) {
  //      for (index, chatMessage) in chat.messages.enumerated()
  //      where chatMessage.messageId == message.messageId {
  //        chat.messages[index].read = true
  //      }
  //    } else {
  //      chat.messages.append(message)
  //    }
  //
  //    chat.messages.sort()
  //    let isLastMessage = chat.messages.firstIndex(of: message) == (chat.messages.count - 1)
  //    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLastMessage
  //    if shouldScrollToBottom {
  //      DispatchQueue.main.async {
  //        self.messagesCollectionView.scrollToBottom(animated: true)
  //      }
  //    }
  //    messagesCollectionView.reloadData()
  //  }
  
  private func message(new newMessage: MessageModel) {
    guard !chat.messages.contains(newMessage) else { return }
    chat.messages.append(newMessage)
    chat.messages.sort()
    
    DispatchQueue.main.async {
      self.messagesCollectionView.scrollToBottom(animated: true)
    }
    messagesCollectionView.reloadData()
  }
  
  //  private func message(updateBy updatedMessage: MessageModel) {
  //    if chat.messages.contains(updatedMessage) {
  //      for (index, chatMessage) in chat.messages.enumerated()
  //      where chatMessage.messageId == updatedMessage.messageId {
  //        chat.messages[index].read = true
  //        chat.messages.sort()
  //      }
  //    }
  //
  //    let isLastMessage = chat.messages.firstIndex(of: updatedMessage) == (chat.messages.count - 1)
  //    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLastMessage
  //    if shouldScrollToBottom {
  //      DispatchQueue.main.async {
  //        self.messagesCollectionView.scrollToBottom(animated: true)
  //      }
  //    }
  //    messagesCollectionView.reloadData()
  //  }
  
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    if isFromCurrentSender(message: message) {
      return .currentUserMessage
    } else {
      return .friendMessage
    }
  }
  
  func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    if isFromCurrentSender(message: message) {
      return .mainDark
    } else {
      return .white
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
      return 10
    }
    
    let distanceBetweenMessages = chat.messages[indexPath.item - 1].sentDate.distance(to: chat.messages[indexPath.item].sentDate)
    let requiredDistanceToDisplayDate = 3.0 * 60 * 60 // 3 hours
    
    if distanceBetweenMessages >= requiredDistanceToDisplayDate {
      return 30
    } else { return 0 }
  }
}

// MARK: - ConfigureMessageInputBar
private extension ChatViewController {
  func setupViews() {
    title = chat.friend.fullName
    
    if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
      layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
      layout.textMessageSizeCalculator.incomingAvatarSize = .zero
    }
    
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .mainDark
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    setupFriendAvatarButton()
    
    messagesCollectionView.backgroundColor = .secondaryDark
    messagesCollectionView.showsVerticalScrollIndicator = false
    messagesCollectionView.hideKeyboardWhenTappedOrSwiped()
    
    messageInputBar.isTranslucent = true
    messageInputBar.blurView.isHidden = true
    messageInputBar.separatorLine.isHidden = false
    messageInputBar.padding.bottom = 5
    messageInputBar.padding.top = 5
    messageInputBar.backgroundView.backgroundColor = .secondaryDark
    messageInputBar.inputTextView.backgroundColor = .mainDark
    messageInputBar.inputTextView.layer.cornerRadius = 20
    messageInputBar.inputTextView.layer.masksToBounds = true
    messageInputBar.inputTextView.placeholderLabel.font = .systemFont(ofSize: 12)
    messageInputBar.inputTextView.placeholder = ChatString.message.localized
    messageInputBar.inputTextView.font = .systemFont(ofSize: 14)
    messageInputBar.inputTextView.isImagePasteEnabled = false
    messageInputBar.inputTextView.autocorrectionType = .default
    messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
    messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
    
    configureSendButton()
  }
  
  func setupFriendAvatarButton() {
    var imageSize: CGFloat = navigationController?.navigationBar.frame.height ?? 0
    if let searchController = navigationController?.navigationBar.topItem?.searchController {
      imageSize -= searchController.searchBar.frame.height
    }
    imageSize *= 0.9
    let avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
    avatarImageView.contentMode = .scaleAspectFill
    avatarImageView.layer.cornerRadius = imageSize/2
    avatarImageView.clipsToBounds = true
    
    avatarImageView.sd_setImage(with: URL(string: chat.friend.avatarString)) { [weak self] image, _, _, _ in
      guard image != nil else { return }
      let customView = UIView(frame: avatarImageView.frame)
      customView.addSubview(avatarImageView)
      
      let menuItems: [UIAction] = [
        UIAction(title: ChatString.reportThisUser.localized, image: UIImage(systemName: "megaphone"), handler: reportFriendAction),
        UIAction(title: ChatString.blockThisUser.localized, image: UIImage(systemName: "xmark.circle"), handler: blockFriendAction),
        UIAction(title: ChatString.deleteThisChat.localized, image: UIImage(systemName: "trash"), attributes: .destructive, handler: deleteChatAction)
      ]
      
      let actionsMenu = UIMenu(title: ChatString.availableActions.localized, image: nil, identifier: nil, options: [], children: menuItems)
      
      let avatarButton = UIButton(type: .system)
      avatarButton.frame = customView.bounds
      avatarButton.menu = actionsMenu
      avatarButton.showsMenuAsPrimaryAction = true
      customView.addSubview(avatarButton)
      
      let customBarButtonItem = UIBarButtonItem(customView: customView)
      self?.navigationItem.rightBarButtonItem = customBarButtonItem
    }
    
    func reportFriendAction(_ action: UIAction) {
      presenter.report(chat.friend, by: currentUser)
    }
    func blockFriendAction(_ action: UIAction) {
      presenter.block(chat, by: currentUser)
    }
    func deleteChatAction(_ action: UIAction) {
      presenter.delete(chat, by: currentUser)
    }
  }
  
  func configureSendButton() {
    messageInputBar.sendButton.setImage(UIImage(named: "activeSendButton"), for: .normal)
    messageInputBar.sendButton.setImage(UIImage(named: "inactiveSendButton"), for: .disabled)
    messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    messageInputBar.sendButton.setSize(CGSize(width: 40, height: 40), animated: false)
  }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
  func currentSender() -> MessageKit.SenderType {
    Sender(senderID: currentUser.id, senderName: currentUser.fullName)
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
    return chat.messages[indexPath.item]
  }
  
  func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
    chat.messages.count
  }
  
  func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
    return 1
  }
  
  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    if indexPath.item == 0 {
      return displayDate(for: message)
    }
    
    let distanceBetweenMessages = chat.messages[indexPath.item - 1].sentDate.distance(to: chat.messages[indexPath.item].sentDate)
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
    FirestoreService.shared.message(send: message, by: currentUser, to: chat) { [weak self] error in
      if let error = error {
        self?.showAlert(with: ChatsString.error.localized, and: error)
      } else {
        self?.messagesCollectionView.scrollToBottom(animated: true)
      }
    }
    inputBar.inputTextView.text = ""
  }
}

// MARK: - ChatViewControllerProtocol
extension ChatViewController: ChatViewControllerProtocol { }
