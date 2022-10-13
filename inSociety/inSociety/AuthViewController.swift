//
//  ViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
//    let backgroundImage = UIImageView(image: .authVCBackground(), contentMode: .scaleAspectFill)
    
    let logoImage = UIImageView(image: .inSociety(), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let loginLabel = UILabel(text: "Already on board?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .emailButtonColor())
    let loginButton = UIButton(title: "Login", titleColor: .loginButtonColor(), backgroundColor: .white, isShadow: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        view.backgroundColor = .systemGray
        setupViews()
    }
    
    private func setupViews() {
        
        view.addSubview(logoImage)
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 0.34)
        ])
        
        
        let googleView = LabelButtonView(label: googleLabel, button: googleButton)
        let emailView = LabelButtonView(label: emailLabel, button: emailButton)
        let loginView = LabelButtonView(label: loginLabel, button: loginButton)
        
        
        view.addSubview(googleView)
        view.addSubview(emailView)
        view.addSubview(loginView)
        
        googleView.translatesAutoresizingMaskIntoConstraints = false
        emailView.translatesAutoresizingMaskIntoConstraints = false
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            googleView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            googleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emailView.topAnchor.constraint(equalTo: googleView.bottomAnchor, constant: 40),
            emailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            loginView.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 40),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
    }
}



//MARK: - SwiftUI
import SwiftUI

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let authViewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return authViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

