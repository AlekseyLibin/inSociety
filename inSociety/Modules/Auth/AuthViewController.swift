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

protocol AuthViewControllerProtocol: AnyObject {
    func present(viewController: UIViewController)
    func showAlert(with title: String, and message: String?, completion: @escaping () -> Void)
}

final class AuthViewController: BaseViewController {
    
    private let logoImage = UIImageView(named: "inSociety", contentMode: .scaleAspectFit)
    private let googleLabel = UILabel(text: "Get started with")
    private let emailLabel = UILabel(text: "Or sign up with")
    private let loginLabel = UILabel(text: "Already on board?")
    
    private let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white)
    private let emailButton = UIButton(title: "email", titleColor: .black, backgroundColor: .mainYellow())
    private let loginButton = UIButton(title: "Login", titleColor: .mainYellow(), backgroundColor: nil)
    
    var presenter: AuthPresenterInputProtocol!
    private let configurator: AuthConfiguratorProtocol = AuthConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        setupViews()
    }
    
    @objc private func emailButtonPressed() {
        presenter.emailButtonPressed()
    }
    
    @objc func loginButtonPressed() {
        presenter.loginButtonPressed()
    }
    
    @objc private func googleButtonPressed() {
        AuthService.shared.googleLogin(presentingVC: self) { [weak self] result in
            self?.presenter.signInWithGoogle(with: result)
        }
    }
    
}
//MARK: - Setup views
private extension AuthViewController {
    func setupViews() {
        
        view.backgroundColor = .mainDark()
        
        logoImage.setupColor(.mainYellow())
        
        emailButton.addBaseShadow()
        
        loginButton.layer.borderColor = UIColor.mainYellow().cgColor
        loginButton.addBaseShadow()
        loginButton.layer.borderWidth = 2
        
        googleButton.customizeGoogleButton()
        
        emailButton.addTarget(self, action: #selector(emailButtonPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
        
        [googleLabel, emailLabel, loginLabel].forEach { label in
            label.textColor = .lightGray
        }
        
        setupConstraints()
    }
    
    
    func setupConstraints() {
        
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
            
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 0.34),
            
            stackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            secondaryView.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor, constant: -35),
            secondaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            secondaryView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 35)
        ])
    }
}


//MARK: - AuthViewControllerProtocol
extension AuthViewController: AuthViewControllerProtocol {
    
}


