//
//  ProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 01.11.2022.
//

import UIKit
import SDWebImage
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    let currentUser: UserModel
    
    var avatarView = UIImageView()
    var fullNameLabel = UILabel()
    var descriptionLabel = UILabel()
    var activeChatsNumberLabel = UILabel(text: "Active chats data")
    var waitingChatsNumberLabel = UILabel(text: "Waiting chats data")
    
    var logOutButton = UIButton(title: "Log out", titleColor: .systemRed, backgroundColor: .darkButtonColor(), isShadow: false)
    
    
    init(currentUser: UserModel) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.backgroundColor = .mainDark()
        navigationController?.navigationBar.backgroundColor = .mainDark()
        
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        
        fillChatsInformation()
        setupViews()
    }
    
    
    
    @objc private func logOut() {
        let ac = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
            
        }))
        present(ac, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Setup Views
extension ProfileViewController {
    func setupViews() {
        
        view.backgroundColor = .mainDark()
        
        avatarView.sd_setImage(with: URL(string: currentUser.userAvatarString))
        avatarView.clipsToBounds = true
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 10
        avatarView.contentMode = .scaleAspectFill
        
        

        fullNameLabel.text = currentUser.userName
        fullNameLabel.font = .galvji30()
        fullNameLabel.textColor = .mainYellow()
        fullNameLabel.textAlignment = .center
        
        descriptionLabel.text = currentUser.description
        descriptionLabel.numberOfLines = 3
        descriptionLabel.font = .galvji20()
        descriptionLabel.textColor = .mainYellow()
        
        activeChatsNumberLabel.font = .galvji25()
        activeChatsNumberLabel.textColor = .mainYellow()
        
        waitingChatsNumberLabel.font = .galvji25()
        waitingChatsNumberLabel.textColor = .mainYellow()
        
        
        let secondaryView = UIView()
        secondaryView.layer.cornerRadius = 20
        secondaryView.backgroundColor = .secondaryDark()
        
        [avatarView, secondaryView, fullNameLabel, descriptionLabel, activeChatsNumberLabel, waitingChatsNumberLabel, logOutButton].forEach { subView in
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),
            
            fullNameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 40),
            fullNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 30),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activeChatsNumberLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 120),
            activeChatsNumberLabel.widthAnchor.constraint(equalToConstant: 250),
            activeChatsNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            waitingChatsNumberLabel.topAnchor.constraint(equalTo: activeChatsNumberLabel.bottomAnchor, constant: 20),
            waitingChatsNumberLabel.widthAnchor.constraint(equalToConstant: 250),
            waitingChatsNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            logOutButton.topAnchor.constraint(equalTo: waitingChatsNumberLabel.bottomAnchor, constant: 70),
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            logOutButton.heightAnchor.constraint(equalToConstant: 50),
            
            secondaryView.topAnchor.constraint(equalTo: fullNameLabel.topAnchor, constant: -25),
            secondaryView.bottomAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant: 25),
            secondaryView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            secondaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
    }
    
    func fillChatsInformation() {
        FirestoreService.shared.getNumberOfActiveChats(for: currentUser) { result in
            switch result {
            case .success(let count):
                self.activeChatsNumberLabel.text = "Active chats: \(count.description)"
            case .failure(let error):
                self.activeChatsNumberLabel.text = "Could not get active chats data \n \(error.localizedDescription)"
            }
        }
        
        FirestoreService.shared.getNumberOfWaitingChats(for: currentUser) { result in
            switch result {
            case .success(let count):
                self.waitingChatsNumberLabel.text = "Waiting chats: \(count.description)"
            case .failure(let error):
                self.activeChatsNumberLabel.text = "Could not get waiting chats data \n \(error.localizedDescription)"
            }
        }
    }
}






//MARK: - SwiftUI
import SwiftUI

struct ProfileVCProvider: PreviewProvider {
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
