//
//  ChatRequestViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(named: "Woman4", contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Ann-Marie Bouvet",
                            font: .systemFont(ofSize: 20, weight: .light))
    let descriptionLabel = UILabel(text: "Chat request",
                                   font: .systemFont(ofSize: 16, weight: .light))
    
    let acceptButton = UIButton(type: .system)
    let denyButton = UIButton(type: .system)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeViews()
        setupConstraints()
    }
    
    private func customizeViews() {
        
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .mainWhite()
        
        descriptionLabel.text = "\(nameLabel.text ?? "") wants to chat with you"
        descriptionLabel.numberOfLines = 0
        
        acceptButton.setTitle("ACCEPT", for: .normal)
        acceptButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .light)
        acceptButton.layer.cornerRadius = 10
        acceptButton.titleLabel?.tintColor = .black
        acceptButton.backgroundColor = .systemYellow
        
        denyButton.setTitle("Deny", for: .normal)
        denyButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .light)
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.cornerRadius = 10
        denyButton.layer.borderColor = UIColor.black.cgColor
        denyButton.tintColor = .systemYellow
        
    }
    
    private func setupConstraints() {
        
        let buttonStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton],
                                           axis: .horizontal, spacing: 20)
        buttonStackView.distribution = .fillEqually
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(buttonStackView)
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
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



//MARK: - SwiftUI
import SwiftUI

struct CharRequestVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let chatRequestViewController = ChatRequestViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return chatRequestViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
