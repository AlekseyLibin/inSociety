//
//  ProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(named: "Woman4", contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Ann-Marie Bouvet",
                            font: .systemFont(ofSize: 20, weight: .light))
    let descriptionLabel = UILabel(text: "I like flowers, music, pankaces and you",
                                   font: .systemFont(ofSize: 16, weight: .light))
    let sendMessageTextField = SendMessageTextField()
    
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
        print(#function)
    }
}



extension ProfileViewController {
    
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



//MARK: - SwiftUI
import SwiftUI

struct ProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let profileViewController = ProfileViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return profileViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
