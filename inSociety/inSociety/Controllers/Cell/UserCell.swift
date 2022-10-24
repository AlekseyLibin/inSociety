//
//  UserCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    let userImageView = UIImageView()
    let userNameLabel = UILabel(text: "Aleksey Libin", font: .laoSangamMN20())
    let containerView = UIView()
    
    static var reuseId: String = "UserCell"

    func configure<U>(with value: U) where U : Hashable {
        guard let user: UserModel = value as? UserModel else { return }
        userImageView.image = UIImage(named: user.userAvatarString)
        userNameLabel.text = user.userName
        userNameLabel.textAlignment = .center
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        backgroundColor = .white
        self.layer.shadowColor = UIColor.shadowColor()?.cgColor
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.layer.cornerRadius = 5
        self.containerView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            userImageView.topAnchor.constraint(equalTo: self.topAnchor),
            userImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            userImageView.heightAnchor.constraint(equalTo: self.widthAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - SwiftUI
import SwiftUI

struct UserChatCellProvider: PreviewProvider {
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
