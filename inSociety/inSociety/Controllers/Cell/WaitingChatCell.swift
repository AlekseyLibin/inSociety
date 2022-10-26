//
//  WaitingChatCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 17.10.2022.
//

import UIKit

class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    //HCell - Hashable cell
    func configure<HCell>(with value: HCell) where HCell : Hashable {
        guard let user: ActiveChatModel = value as? ActiveChatModel else { return }
        userImage.image = UIImage(named: user.userAvatarString)
    }
    
    static var reuseId: String = "WaitingChatCell"
    
    let userImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userImage)
        
        NSLayoutConstraint.activate([
            userImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userImage.widthAnchor.constraint(equalTo: self.widthAnchor),
            userImage.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - SwiftUI
import SwiftUI

struct WaitingChatCellProvider: PreviewProvider {
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
