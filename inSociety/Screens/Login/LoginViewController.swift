//
//  LoginViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit
import Lottie
import FirebaseCore
import FirebaseAuth

protocol LoginViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?, completion: @escaping () -> Void)
  func showAlert(with title: String, and message: String?)
  func stopLoadingAnimation()
}

final class LoginViewController: BaseViewController {
  
  private let scrollView = UIScrollView()
  private let setupView = UIView()
  
  private let greetingLabel = UILabel(text: LoginString.welcomeBack.localized, font: .light30)
  private let loginWithLabel = UILabel(text: LoginString.loginWith.localized)
  private let orLabel = UILabel(text: LoginString.orSignUpWithAnotherMethod.localized)
  private let emailLabel = UILabel(text: LoginString.email.localized)
  private let passwordLabel = UILabel(text: LoginString.password.localized)
  
  private let emailTextField = UnderlinedTextField(font: .light20)
  private let passwordTextField = UnderlinedTextField(font: .light20)
  
  private let loginButton = CustomButton(title: LoginString.login.localized,
                                     titleColor: .mainYellow, mainBackgroundColor: .mainDark)
  private let googleButton = GoogleButton()
  private let signUpButton = CustomButton(title: LoginString.createNewAccount.localized,
                                      titleColor: .mainYellow, highlight: false)
  
  var presenter: LoginPresenterProtocol!
  private let configurator: LoginConfiguratorProtocol = LoginConfigurator()
  
  private var toSignUpClosure: (() -> Void)?
  
  init(toSignUpClosure: (() -> Void)?) {
    self.toSignUpClosure = toSignUpClosure
    super.init(nibName: nil, bundle: nil)
    configurator.configure(with: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpViews()
    prepareLoadingAnimation()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupContentViewSize()
  }
  
  deinit {
    stopLoadingAnimation()
  }
  
  // MARK: - Actions
  @objc private func googleButtonPressed() {
    AuthService.shared.enter(self) { [weak self] result in
      self?.presenter.loginWithGoogle(with: result)
    }
  }
  
  @objc private func loginButtonPressed() {
    presenter.loginWithEmail(email: emailTextField.text, password: passwordTextField.text)
  }
  
  @objc private func signUpButtonPressed(sender: UIButton) {
    dismiss(animated: true) {
      self.toSignUpClosure?()
    }
  }
  
  private func setupContentViewSize() {
    let setupViewHeight = setupView.frame.height
    scrollView.contentSize = CGSize(width: view.frame.width, height: setupViewHeight + 250)
  }
  
}

// MARK: - Setup views
private extension LoginViewController {
  func setUpViews() {
    view.backgroundColor = .mainDark
    
    scrollView.showsVerticalScrollIndicator = false
    scrollView.delaysContentTouches = false
    scrollView.hideKeyboardWhenTappedOrSwiped()
    scrollView.addKeyboardObservers()
    
    [greetingLabel, emailLabel, passwordLabel].forEach { label in
      label.textColor = .mainYellow
    }
    
    loginWithLabel.textColor = .lightGray
    orLabel.textColor = .lightGray
    
    signUpButton.addBaseShadow()
    
    loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
    googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
    
    emailTextField.autocapitalizationType = .none
    emailTextField.autocorrectionType = .no
    passwordTextField.autocapitalizationType = .none
    passwordTextField.autocorrectionType = .no
    passwordTextField.isSecureTextEntry = true
    
    setupConstraints()
  }
  
  func setupConstraints() {
    let loginView = LabelButtonView(label: loginWithLabel, button: googleButton)
    let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField],
                                     axis: .vertical, spacing: 10)
    let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                        axis: .vertical, spacing: 10)
    let setupStackView = UIStackView(arrangedSubviews:
                                  [ loginView, orLabel, emailStackView, passwordStackView, loginButton],
                                axis: .vertical, spacing: 40)
    
    setupView.layer.cornerRadius = 20
    setupView.backgroundColor = .secondaryDark
    googleButton.layer.cornerRadius = 15
    
    view.addSubview(scrollView)
    scrollView.addSubview(greetingLabel)
    scrollView.addSubview(setupView)
    scrollView.addSubview(setupStackView)
    scrollView.addSubview(signUpButton)
    
    [scrollView, greetingLabel, setupStackView, setupView, signUpButton].forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      greetingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
      greetingLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      
      setupStackView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 125),
      setupStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      setupStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
      
      setupView.topAnchor.constraint(equalTo: setupStackView.topAnchor, constant: -30),
      setupView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      setupView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
      setupView.bottomAnchor.constraint(equalTo: setupStackView.bottomAnchor, constant: 30),
      
      googleButton.heightAnchor.constraint(equalToConstant: 50),
      
      signUpButton.topAnchor.constraint(equalTo: setupView.bottomAnchor, constant: 15),
      signUpButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      
      loginButton.heightAnchor.constraint(equalToConstant: 60)
    ])
    
  }
}

// MARK: - LoginViewControllerProtocol
extension LoginViewController: LoginViewControllerProtocol { }
