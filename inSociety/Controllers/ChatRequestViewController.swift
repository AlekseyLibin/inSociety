//
//  ChatRequestViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel(text: "",
                                    font: .systemFont(ofSize: 20, weight: .light))
    private let descriptionLabel = UILabel(text: "Chat request",
                                           font: .systemFont(ofSize: 16, weight: .light))
    
    private let acceptButton = UIButton(type: .system)
    private let denyButton = UIButton(type: .system)
    
    private var chat: ChatModel
    
    weak var delegate: WaitingChatsNavigation?
    
    init(chat: ChatModel) {
        self.chat = chat
        imageView.sd_setImage(with: URL(string: chat.friendAvatarString))
        nameLabel.text = chat.friendName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        denyButton.addTarget(self, action: #selector(deny), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(accept), for: .touchUpInside)
        
    }
    
    @objc private func deny() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }
    
    @objc private func accept() {
        self.dismiss(animated: true) {
            self.delegate?.moveToActive(chat: self.chat)
        }
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .mainDark()
        
        nameLabel.textColor = .mainWhite()
        
        descriptionLabel.text = "\(nameLabel.text ?? "Somebody") wants to chat with you"
        descriptionLabel.textColor = .mainWhite()
        descriptionLabel.numberOfLines = 0
        
        acceptButton.setTitle("ACCEPT", for: .normal)
        acceptButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .light)
        acceptButton.layer.cornerRadius = 10
        acceptButton.titleLabel?.tintColor = .black
        acceptButton.backgroundColor = .mainYellow()
        
        denyButton.setTitle("Deny", for: .normal)
        denyButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .light)
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.cornerRadius = 10
        denyButton.layer.borderColor = UIColor.secondaryDark().cgColor
        denyButton.tintColor = .mainYellow()
        
        let buttonStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton],
                                          axis: .horizontal, spacing: 20)
        buttonStackView.distribution = .fillEqually
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(buttonStackView)
        
        [containerView, imageView, nameLabel, descriptionLabel, buttonStackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            
            containerView.heightAnchor.constraint(equalToConstant: 210),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
}
