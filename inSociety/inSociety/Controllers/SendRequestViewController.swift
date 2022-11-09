//
//  ProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import SDWebImage

class SendRequestViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    let containerView = UIView()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let sendMessageTextField = SendMessageTextField()
    
    
    let user: UserModel
    
    init(user: UserModel) {
        self.user = user
        
        self.nameLabel.text = user.userName
        self.descriptionLabel.text = user.description
        self.imageView.sd_setImage(with: URL(string: user.userAvatarString))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        if let button = sendMessageTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        scrollView.contentSize = view.frame.size
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Button realization
extension SendRequestViewController {
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



//MARK: - Setup views
extension SendRequestViewController {
    private func setupViews() {
        
        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFill
        
        scrollView.hideKeyboardWhenTappedOrSwiped()
        scrollView.addKeyboardObservers()
        scrollView.contentSize.height = view.frame.height/1.07   //On a modally presented VC height is different
        scrollView.contentSize.width = view.frame.width
        
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .mainDark()
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .light)
        nameLabel.textColor = .mainWhite()
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .mainWhite()
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .light)

        view.addSubview(imageView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(sendMessageTextField)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        sendMessageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: view.frame.height/1.07),
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 210),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            

            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),

            sendMessageTextField.heightAnchor.constraint(equalToConstant: 50),
            sendMessageTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            sendMessageTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            sendMessageTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
        ])
    }
    
}
