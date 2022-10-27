//
//  ActiveChatCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 17.10.2022.
//

import UIKit

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "ActiveChatCell"
    
    //HCell - Hashable cell
    func configure<HCell>(with value: HCell) where HCell : Hashable {
        guard let user: ChatModel = value as? ChatModel else { return }
        
        backgroundColor = .white
        userImageView.sd_setImage(with: URL(string: user.friendAvatarString))
        userName.text = user.friendName
        lastMessage.text = user.lastMessageContent
        
//        gradientView.backgroundColor = .systemYellow
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.frame = self.frame
    }
    
    
        
    let userImageView = UIImageView()
    let userName = UILabel(text: "User name", font: .laoSangamMN20())
    let lastMessage = UILabel(text: "Last message", font: .laoSangamMN18())
    let gradientView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientView.backgroundColor = .systemPurple
        
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        setupConstraints()
    }
    
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActiveChatCell {
    func setupGradient() {
        
        
    }
}




//MARK: - Setup Constraints
extension ActiveChatCell {
    private func setupConstraints() {
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(userImageView)
        self.addSubview(userName)
        self.addSubview(lastMessage)
        self.addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            userImageView.widthAnchor.constraint(equalTo: heightAnchor),
            
            userName.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor,
                                              constant: 30),
            userName.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            userName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -10),
            
            lastMessage.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor,
                                                 constant: 20),
            lastMessage.topAnchor.constraint(equalTo: userName.bottomAnchor,
                                             constant: 10),
            lastMessage.trailingAnchor.constraint(equalTo: userName.trailingAnchor),
            
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalTo: self.heightAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
}



//MARK: - SwiftUI
import SwiftUI

struct ActiveChatCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let mainTabBarController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

