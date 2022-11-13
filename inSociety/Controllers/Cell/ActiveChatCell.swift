//
//  ActiveChatCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 17.10.2022.
//

import UIKit

class ActiveChatCell: UICollectionViewCell {
    
    static var reuseID = "ActiveChatCell"
    
    private let userImageView = UIImageView()
    private let userName = UILabel(text: "User name", font: .laoSangamMN20())
    private let lastMessage = UILabel(text: "Last message", font: .laoSangamMN18())
    private let stripView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLastMessage(with content: String) {
        self.lastMessage.text = content
    }
}



//MARK: - SelfConfiguringCell
extension ActiveChatCell: SelfConfiguringCell {
    
    //HCell - Hashable cell
    func configure<HCell>(with value: HCell) where HCell : Hashable {
        guard let user: ChatModel = value as? ChatModel else { return }
        
        backgroundColor = .secondaryDark()
        userImageView.sd_setImage(with: URL(string: user.friendAvatarString))
        userName.text = user.friendName
        lastMessage.text = user.lastMessageContent
        
    }
}



//MARK: - Setup Constraints
extension ActiveChatCell {
    private func setupViews() {
        
        stripView.backgroundColor = .mainYellow()
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        [userImageView, userName, lastMessage, stripView].forEach { view in
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        userName.textColor = .lightGray
        lastMessage.textColor = .systemGray
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            userImageView.widthAnchor.constraint(equalTo: heightAnchor),
            
            userName.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor,
                                              constant: 40),
            userName.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            userName.trailingAnchor.constraint(equalTo: stripView.leadingAnchor, constant: -10),
            
            lastMessage.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor,
                                                 constant: 20),
            lastMessage.topAnchor.constraint(equalTo: userName.bottomAnchor,
                                             constant: 10),
            lastMessage.trailingAnchor.constraint(equalTo: userName.trailingAnchor),
            
            stripView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stripView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stripView.heightAnchor.constraint(equalTo: self.heightAnchor),
            stripView.widthAnchor.constraint(equalToConstant: 5)
        ])
    }
}

