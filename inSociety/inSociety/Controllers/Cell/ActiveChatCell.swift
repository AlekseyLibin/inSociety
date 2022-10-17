//
//  ActiveChatCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 17.10.2022.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure(with value: ActiveChatModel)
}

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "ActiveChatCell"
    func configure(with value: ActiveChatModel) {
        
        backgroundColor = .white
        userImageView.image = UIImage(named: value.userImageString)
        userName.text = value.userName
        lastMessage.text = value.lastMessage
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

