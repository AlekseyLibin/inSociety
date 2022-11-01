//
//  ProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import SDWebImage

class SendReqestViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(named: "Woman4", contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Ann-Marie Bouvet",
                            font: .systemFont(ofSize: 20, weight: .light))
    let descriptionLabel = UILabel(text: "I am Ann-Marie",
                                   font: .systemFont(ofSize: 16, weight: .light))
    let sendMessageTextField = SendMessageTextField()
    
    
    let user: UserModel
    
    init(user: UserModel) {
        self.user = user
        
        self.nameLabel.text = user.userName
        self.descriptionLabel.text = user.description
        self.imageView.sd_setImage(with: URL(string: user.userAvatarString))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeElements()
        setupConstraints()
    }
    
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        sendMessageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.numberOfLines = 0
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .mainWhite()
        
        if let button = sendMessageTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        }
    }
    
     @objc private func sendButtonPressed() {
         guard
             let message = sendMessageTextField.text,
             !message.isEmpty
         else { return }
         
         self.dismiss(animated: true) {
             FirestoreService.shared.createWaitingChat(message: message, receiver: self.user) { result in
                 switch result {
                 case .success:
                     guard let currentUser = FirestoreService.shared.currentUser else { return }
                     let chat = ChatModel(friendName: self.user.userName,
                                          friendAvatarString: self.user.userAvatarString,
                                          lastMessageContent: message,
                                          friendID: self.user.id)
                     let message = MessageModel(user: currentUser, content: message)
                     FirestoreService.shared.createActiveChat(chat: chat, messages: [message]) { result in
                         switch result {
                         case .success:
                             UIApplication.getTopViewController()?.showAlert(with: "Success", and: "Your message and chat request have been sent to \(self.user.userName)")
                         case .failure(let error):
                             UIApplication.getTopViewController()?.showAlert(with: "Error", and: error.localizedDescription)
                         }
                     }
                 case .failure(let error):
                     UIApplication.getTopViewController()?.showAlert(with: "Error", and: error.localizedDescription)
                 }
             }
         }
     }


}



extension SendReqestViewController {
    
    private func setupConstraints() {
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(sendMessageTextField)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),

            
            containerView.heightAnchor.constraint(equalToConstant: 210),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            sendMessageTextField.heightAnchor.constraint(equalToConstant: 50),
            sendMessageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendMessageTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            sendMessageTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
        ])

    }
    
}
