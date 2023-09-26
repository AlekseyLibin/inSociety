//
//  ActiveChatCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 17.10.2022.
//

import UIKit

final class ActiveChatCell: UICollectionViewCell {
  
  static var reuseID = "ActiveChatCell"
  
  private let userImageView: UIImageView
  private let userNameLabel: UILabel
  private let stripView: UIView
  private let lastMessageContentLabel: UILabel
  private let lastMessageDateLabel:  UILabel
  private let lastMessageBackgroundView: UIView
  
  override init(frame: CGRect) {
    self.userImageView = UIImageView()
    self.stripView = UIView()
    self.lastMessageBackgroundView = UIView()
    self.lastMessageDateLabel = UILabel(text: "", font: .systemFont(ofSize: 10, weight: .light))
    self.userNameLabel = UILabel(text: ActiveChatCellString.userName.localized, font: .systemFont(ofSize: 20, weight: .light))
    self.lastMessageContentLabel = UILabel(text: ActiveChatCellString.lastMessage.localized, font: .italicSystemFont(ofSize: 14))
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func reconfigure(with chat: ChatModel) {
    userNameLabel.text = chat.friend.fullName
    lastMessageContentLabel.text = chat.messages.sorted().last?.content ?? ""
    lastMessageDateLabel(set: chat.messages.sorted().last?.sentDate)
    userImageView.sd_setImage(with: URL(string: chat.friend.avatarString))
    userImageView.contentMode = .scaleAspectFill
    userImageView.layer.masksToBounds = true
  }
}

// MARK: - SelfConfiguringCell
extension ActiveChatCell: SelfConfiguringCell {
  
  // HCell - Hashable cell
  func configure<HCell>(with cell: HCell) where HCell : Hashable {
    guard let activeChat: ChatModel = cell as? ChatModel else { return }
    
    backgroundColor = .secondaryDark
    userImageView.sd_setImage(with: URL(string: activeChat.friend.avatarString))
    userImageView.contentMode = .scaleAspectFill
    userImageView.layer.masksToBounds = true
    userNameLabel.text = activeChat.friend.fullName
    FirestoreService.shared.message(getLastFrom: activeChat) { [ weak self] result in
      switch result {
      case .success(let lastMessage):
        self?.lastMessageContentLabel.text = lastMessage.content
        self?.lastMessageDateLabel(set: lastMessage.sentDate)
      case .failure:
        self?.lastMessageContentLabel.text = activeChat.messages.sorted().last?.content ?? ""
      }
    }
  }
  
  private func lastMessageDateLabel(set date: Date?) {
    guard let date = date else { return }
    let dateFormatter = DateFormatter()
    
    let targetDate = date
    let currentDate = Date()
    let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentDate)!
    
    if Calendar.current.isDateInToday(targetDate) {
      dateFormatter.dateFormat = "HH:mm"
      lastMessageDateLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
    } else if Calendar.current.isDateInYesterday(targetDate) {
      dateFormatter.dateFormat = "'\(ActiveChatCellString.yesterday.localized)'"
      lastMessageDateLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    } else if targetDate >= oneWeekAgo {
      dateFormatter.dateFormat = "EEE"
      lastMessageDateLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
    } else {
      dateFormatter.dateFormat = "dd:MM"
      lastMessageDateLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    let formattedString = dateFormatter.string(from: targetDate)
    lastMessageDateLabel.text = formattedString
  }
}

// MARK: - Setup Constraints
extension ActiveChatCell {
  private func setupViews() {
    
    stripView.backgroundColor = .mainYellow
    
    lastMessageBackgroundView.backgroundColor = .mainDark
    lastMessageBackgroundView.alpha = 0.5
    lastMessageBackgroundView.layer.cornerRadius = 10
    
    lastMessageDateLabel.textAlignment = .right
    lastMessageDateLabel.textColor = .lightGray
    lastMessageDateLabel.adjustsFontSizeToFitWidth = true
    
    self.layer.cornerRadius = 4
    self.clipsToBounds = true
    
    [userImageView, userNameLabel, lastMessageBackgroundView, lastMessageContentLabel, lastMessageDateLabel, stripView].forEach { view in
      self.addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    userNameLabel.textColor = .white
    lastMessageContentLabel.textColor = .lightGray
    
    NSLayoutConstraint.activate([
      userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      userImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
      userImageView.widthAnchor.constraint(equalTo: heightAnchor),
      
      userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor,
                                             constant: 40),
      userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      userNameLabel.trailingAnchor.constraint(equalTo: stripView.leadingAnchor, constant: -10),
      
      lastMessageBackgroundView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
      lastMessageBackgroundView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
      lastMessageBackgroundView.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: -10),
      lastMessageBackgroundView.heightAnchor.constraint(equalTo: lastMessageContentLabel.heightAnchor, multiplier: 1.5),
      
      lastMessageDateLabel.topAnchor.constraint(equalTo: lastMessageContentLabel.topAnchor),
      lastMessageDateLabel.trailingAnchor.constraint(equalTo: lastMessageBackgroundView.trailingAnchor, constant: -10),
      lastMessageDateLabel.bottomAnchor.constraint(equalTo: lastMessageContentLabel.bottomAnchor),
      
      lastMessageContentLabel.topAnchor.constraint(equalTo: lastMessageBackgroundView.topAnchor, constant: 5),
      lastMessageContentLabel.trailingAnchor.constraint(equalTo: lastMessageDateLabel.leadingAnchor, constant: -10),
      lastMessageContentLabel.leadingAnchor.constraint(equalTo: lastMessageBackgroundView.leadingAnchor, constant: 10),
      
      stripView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      stripView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      stripView.heightAnchor.constraint(equalTo: self.heightAnchor),
      stripView.widthAnchor.constraint(equalToConstant: 5)
    ])
  }
}
