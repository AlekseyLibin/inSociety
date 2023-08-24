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
  private let lastMessageLabel: UILabel
  private let stripView: UIView
  private let lastMessageBackgroundView: UIView
  
  override init(frame: CGRect) {
    self.userImageView = UIImageView()
    self.stripView = UIView()
    self.lastMessageBackgroundView = UIView()
    self.userNameLabel = UILabel(text: ActiveChatCellString.userName.localized, font: .laoSangamMN20())
    self.lastMessageLabel = UILabel(text: ActiveChatCellString.lastMessage.localized, font: .laoSangamMN14())
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateLastMessage(with content: String) {
    self.lastMessageLabel.text = content
  }
}

// MARK: - SelfConfiguringCell
extension ActiveChatCell: SelfConfiguringCell {
  
  // HCell - Hashable cell
  func configure<HCell>(with value: HCell) where HCell : Hashable {
    guard let user: ChatModel = value as? ChatModel else { return }
    
    backgroundColor = .secondaryDark()
    userImageView.sd_setImage(with: URL(string: user.friendAvatarString))
    userImageView.contentMode = .scaleAspectFill
    userImageView.layer.masksToBounds = true
    userNameLabel.text = user.friendName
    FirestoreService.shared.getLastMessage(chat: user) { [ weak self] result in
      switch result {
      case .success(let lastMessage):
        self?.lastMessageLabel.text = lastMessage.content
      case .failure:
        self?.lastMessageLabel.text = user.lastMessageContent
      }
    }
  }
}

// MARK: - Setup Constraints
extension ActiveChatCell {
  private func setupViews() {
    
    stripView.backgroundColor = .mainYellow()
    lastMessageBackgroundView.backgroundColor = .mainDark()
    lastMessageBackgroundView.alpha = 0.5
    lastMessageBackgroundView.layer.cornerRadius = 10
    
    self.layer.cornerRadius = 4
    self.clipsToBounds = true
    
    [userImageView, userNameLabel, lastMessageBackgroundView, lastMessageLabel, stripView].forEach { view in
      self.addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    userNameLabel.textColor = .mainWhite()
    lastMessageLabel.textColor = .lightGray
    
    NSLayoutConstraint.activate([
      userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      userImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
      userImageView.widthAnchor.constraint(equalTo: heightAnchor),
      
      userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor,
                                        constant: 40),
      userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      userNameLabel.trailingAnchor.constraint(equalTo: stripView.leadingAnchor, constant: -10),
      
      lastMessageBackgroundView.centerYAnchor.constraint(equalTo: lastMessageLabel.centerYAnchor),
      lastMessageBackgroundView.centerXAnchor.constraint(equalTo: lastMessageLabel.centerXAnchor),
      lastMessageBackgroundView.heightAnchor.constraint(equalTo: lastMessageLabel.heightAnchor, multiplier: 1.5),
      lastMessageBackgroundView.widthAnchor.constraint(equalTo: lastMessageLabel.widthAnchor, constant: 20),
      
      lastMessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 15),
      lastMessageLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: -20),
      lastMessageLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20),
      
      stripView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      stripView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      stripView.heightAnchor.constraint(equalTo: self.heightAnchor),
      stripView.widthAnchor.constraint(equalToConstant: 5)
    ])
  }
}
