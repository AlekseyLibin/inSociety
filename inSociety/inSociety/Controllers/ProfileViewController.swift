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
    
    var logOutButton = UIButton(type: .system)
    
    
    init(currentUser: UserModel) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite()
        
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
        
        avatarView.sd_setImage(with: URL(string: currentUser.userAvatarString))
        avatarView.contentMode = .scaleToFill

        fullNameLabel.text = currentUser.userName
        fullNameLabel.backgroundColor = .green
        fullNameLabel.textAlignment = .center
        
        descriptionLabel.text = currentUser.description
        descriptionLabel.backgroundColor = .green
        
        
        activeChatsNumberLabel.backgroundColor = .green
        waitingChatsNumberLabel.backgroundColor = .green

        logOutButton.backgroundColor = .systemGray
        logOutButton.setTitle("Log out", for: .normal)
        
        
        view.addSubview(avatarView)
        view.addSubview(fullNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(activeChatsNumberLabel)
        view.addSubview(waitingChatsNumberLabel)
        view.addSubview(logOutButton)
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        activeChatsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        waitingChatsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),
            
            fullNameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 50),
            fullNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 30),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activeChatsNumberLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50),
            activeChatsNumberLabel.widthAnchor.constraint(equalToConstant: 200),
            activeChatsNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            waitingChatsNumberLabel.topAnchor.constraint(equalTo: activeChatsNumberLabel.bottomAnchor, constant: 20),
            waitingChatsNumberLabel.widthAnchor.constraint(equalToConstant: 200),
            waitingChatsNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            logOutButton.topAnchor.constraint(equalTo: waitingChatsNumberLabel.bottomAnchor, constant: 100),
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            logOutButton.heightAnchor.constraint(equalToConstant: 60)
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






////MARK: - SwiftUI
//import SwiftUI
//
//struct ProfileVCProvider: PreviewProvider {
//    static var previews: some View {
//        ContainerView().edgesIgnoringSafeArea(.all)
//    }
//
//    struct ContainerView: UIViewControllerRepresentable {
//        let mainTabBarController = MainTabBarController()
//
//        func makeUIViewController(context: Context) -> some UIViewController {
//            return mainTabBarController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//        }
//    }
//}
