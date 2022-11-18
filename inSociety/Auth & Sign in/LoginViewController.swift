//
//  LoginViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    weak var delegate: AuthNavigationDelegate?
    
    private let scrollView = UIScrollView()
    
    private let greetingLabel = UILabel(text: "Welcome back!", font: .galvji30())
    private let loginWithLabel = UILabel(text: "Login with")
    private let orLabel = UILabel(text: "or")
    private let emailLabel = UILabel(text: "Email")
    private let passwordLabel = UILabel(text: "Password")
    
    private let emailTextField = UnderlinedTextField(font: .galvji20())
    private let passwordTextField = UnderlinedTextField(font: .galvji20())
    
    private let loginButton = UIButton(title: "Login",
                                       titleColor: .white, backgroundColor: .darkButtonColor())
    private let googleButton = UIButton(title: "Google",
                                        titleColor: .black, backgroundColor: .white)
    private let signUpButton = UIButton(title: "Create new account",
                                        titleColor: .mainYellow(), backgroundColor: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = view.frame.size
    }
    
    @objc private func loginButtonPressed() {
        AuthService.shared.login(email: emailTextField.text,
                                 password: passwordTextField.text) { [weak self] result in
            self?.tryToLogin(with: result)
        }
    }
    
    @objc private func signUpButtonPressed() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
    
    @objc private func googleButtonPressed() {
        let clientID = FirebaseApp.app()?.options.clientID
        AuthService.shared.googleLogin(clientID: clientID, presentingVC: self) { [weak self] result in
            self?.tryToLogin(with: result)
        }
    }
    
    private func tryToLogin(with options: Result<User, Error>) {
        switch options {
        case .success(let user):
            FirestoreService.shared.getUserData(user: user) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let currentUser):
                    let mainTabBar = MainTabBarController(currentUser: currentUser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.present(mainTabBar, animated: true)
                case .failure(_):
                    self.present(SetupProfileViewController(currentUser: user), animated: true)
                }
            }
        case .failure(let error):
            self.showAlert(with: "Error", and: error.localizedDescription)
        }
    }
}


//MARK: - Setup views
private extension LoginViewController {
    func setUpViews() {
        
        view.backgroundColor = .mainDark()
        
        scrollView.hideKeyboardWhenTappedOrSwiped()
        scrollView.addKeyboardObservers()
        
        [greetingLabel, emailLabel, passwordLabel].forEach { label in
            label.textColor = .mainYellow()
        }
        
        loginWithLabel.textColor = .lightGray
        orLabel.textColor = .lightGray
        
        googleButton.customizeGoogleButton()
        
        signUpButton.addBaseShadow()
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
        
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        
        
        view.addSubview(scrollView)
        
        setupConstraints()
    }
    
    
    func setupConstraints() {
        
        let loginView = LabelButtonView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField],
                                         axis: .vertical, spacing: 10)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                            axis: .vertical, spacing: 10)
        let stackView = UIStackView(arrangedSubviews:
                                        [ loginView, orLabel, emailStackView, passwordStackView, loginButton, signUpButton ],
                                    axis: .vertical, spacing: 40)
        
        let secondaryView = UIView()
        secondaryView.layer.cornerRadius = 20
        secondaryView.backgroundColor = .secondaryDark()
        
        scrollView.addSubview(greetingLabel)
        scrollView.addSubview(secondaryView)
        scrollView.addSubview(stackView)
        
        [scrollView, greetingLabel, stackView, secondaryView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            greetingLabel.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 75),
            greetingLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            
            secondaryView.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor, constant: -30),
            secondaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            secondaryView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
}
