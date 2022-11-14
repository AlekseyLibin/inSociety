//
//  ViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class AuthViewController: UIViewController {
    
    private let logoImage = UIImageView(named: "inSociety", contentMode: .scaleAspectFit)
    private let googleLabel = UILabel(text: "Get started with")
    private let emailLabel = UILabel(text: "Or sign up with")
    private let loginLabel = UILabel(text: "Already on board?")
    
    private let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white)
    private let emailButton = UIButton(title: "email", titleColor: .black, backgroundColor: .mainYellow())
    private let loginButton = UIButton(title: "Login", titleColor: .mainYellow(), backgroundColor: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @objc private func emailButtonPressed() {
        toSignUpVC()
    }
    
    @objc func loginButtonPressed() {
        toLoginVC()
    }
    
    @objc private func googleButtonPressed() {
        let clientID = FirebaseApp.app()?.options.clientID
        AuthService.shared.googleLogin(clientID: clientID, presentingVC: self) { [weak self] result in
            switch result {
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { [weak self] result in
                    switch result {
                    case .success(let userModel):
                        
                        let main = MainTabBarController(currentUser: userModel)
                        main.modalPresentationStyle = .fullScreen
                        self?.present(main, animated: true)
                    case .failure(_):
                        self?.showAlert(with: "You have successfully registrated") {
                            self?.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                }
            case .failure(let failure):
                self?.showAlert(with: "Error", and: failure.localizedDescription)
            }
        }
    }
    
}


//MARK: - Setup views
private extension AuthViewController {
    func setupViews() {
        
        view.backgroundColor = .mainDark()
        
        logoImage.setupColor(.mainYellow())
        
        loginButton.layer.borderColor = UIColor.mainYellow().cgColor
        loginButton.layer.borderWidth = 2
        
        googleButton.customizeGoogleButton()
        
        emailButton.addTarget(self, action: #selector(emailButtonPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
        
        [googleLabel, emailLabel, loginLabel].forEach { label in
            label.textColor = .lightGray
        }
        
        let googleView = LabelButtonView(label: googleLabel, button: googleButton)
        let emailView = LabelButtonView(label: emailLabel, button: emailButton)
        let loginView = LabelButtonView(label: loginLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView],
                                    axis: .vertical, spacing: 50)
        
        let secondaryView = UIView()
        secondaryView.layer.cornerRadius = 20
        secondaryView.backgroundColor = .secondaryDark()
        
        [logoImage, secondaryView, stackView].forEach { subView in
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 0.34),
            
            stackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            secondaryView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -35),
            secondaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            secondaryView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 35)
        ])
        
    }
}


//MARK: - AuthNavigationDelegate
extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        present(loginVC, animated: true)
    }
    
    func toSignUpVC() {
        let signUpVC = SignUpViewController()
        signUpVC.delegate = self
        present(signUpVC, animated: true)
    }
}

