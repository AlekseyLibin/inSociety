//
//  LoginViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

protocol LoginViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?, completion: @escaping () -> Void)
  func showAlert(with title: String, and message: String?)
}

final class LoginViewController: BaseViewController {
  
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
  
  var presenter: LoginPresenterProtocol!
  private let configurator: LoginConfiguratorProtocol = LoginConfigurator()
  
  private var toSignUpClosure: (() -> Void)?
  
  init(toSignUpClosure: (() -> Void)?) {
    self.toSignUpClosure = toSignUpClosure
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configurator.configure(with: self)
    setUpViews()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    scrollView.contentSize = view.frame.size
  }
  
  @objc private func loginButtonPressed() {
    presenter.loginWithEmail(email: emailTextField.text, password: passwordTextField.text)
  }
  
  @objc private func signUpButtonPressed() {
    dismiss(animated: true) {
      self.toSignUpClosure?()
    }
  }
  
  @objc private func googleButtonPressed() {
    AuthService.shared.googleLogin(presentingVC: self) { [weak self] result in
      self?.presenter.loginWithGoogle(with: result)
    }
  }
  
}

// MARK: - Setup views
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

// MARK: - LoginViewControllerProtocol
extension LoginViewController: LoginViewControllerProtocol {
  
}
