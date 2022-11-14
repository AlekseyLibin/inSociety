//
//  WaitingChatCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 17.10.2022.
//

import UIKit

class WaitingChatCell: UICollectionViewCell {
    
    static var reuseID: String = "WaitingChatCell"
    
    private let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - SelfConfiguringCell
extension WaitingChatCell: SelfConfiguringCell {
    
    //HCell - Hashable cell
    func configure<HCell>(with value: HCell) where HCell : Hashable {
        guard let chat: ChatModel = value as? ChatModel else { return }
        friendImageView.sd_setImage(with: URL(string: chat.friendAvatarString))
    }
}


//MARK: - Setup constraints
private extension WaitingChatCell {
    func setupConstraints() {
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(friendImageView)
        
        NSLayoutConstraint.activate([
            friendImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            friendImageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
