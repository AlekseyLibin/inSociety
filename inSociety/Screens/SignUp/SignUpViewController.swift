//
//  SignUpViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

protocol SignUpViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?)
}

final class SignUpViewController: BaseViewController {
  
  private let scrollView = UIScrollView()
  
  private let greetingLabel = UILabel(text: SignUpString.pleasedToSeeYou.localized, font: .light30)
  private let emailLabel = UILabel(text: SignUpString.email.localized)
  private let passwordLabel = UILabel(text: SignUpString.password.localized)
  private let confirmPasswordLabel = UILabel(text: SignUpString.confirmPassword.localized)
  private let alreadyWithUsLabel = UILabel(text: SignUpString.alreadyWithUs.localized)
  
  private let emailextField = UnderlinedTextField(font: .light20)
  private let passwordTextField = UnderlinedTextField(font: .light20)
  private let confirmPasswordtextField = UnderlinedTextField(font: .light20)
  
  private let signUpButton = UIButton(title: SignUpString.signUp.localized, titleColor: .white, backgroundColor: .mainDark)
  private let loginButton = UIButton(title: SignUpString.login.localized, titleColor: .mainYellow, backgroundColor: nil)
  
  var presenter: SignUpPresenterProtocol!
  private let configurator: SignUpConfiguratorProtocol = SignUpConfigurator()
  
  private var toLoginClosure: (() -> Void)?
  
  init(toLoginClosure: (() -> Void)?) {
    self.toLoginClosure = toLoginClosure
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configurator.configure(viewController: self)
    setUpViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    scrollView.contentSize = view.frame.size
  }
  
  @objc private func signUpButonPressed() {
    presenter.signUpButtonPressed(email: emailextField.text,
                                  password: passwordTextField.text,
                                  confirmPass: confirmPasswordtextField.text)
  }
  
  @objc private func loginButtonPressed() {
    dismiss(animated: true) {
      self.toLoginClosure?()
    }
  }
}

// MARK: - Setup Views
private extension SignUpViewController {
  
  func setUpViews() {
    
    view.backgroundColor = .mainDark
    
    scrollView.hideKeyboardWhenTappedOrSwiped()
//    scrollView.addKeyboardObservers()
    
    loginButton.addBaseShadow()
    signUpButton.addTarget(self, action: #selector(signUpButonPressed), for: .touchUpInside)
    loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    
    [greetingLabel, emailLabel, passwordLabel, confirmPasswordLabel].forEach { label in
      label.textColor = .mainYellow
    }
    
    alreadyWithUsLabel.textColor = .lightGray
    
    emailextField.autocapitalizationType = .none
    emailextField.autocorrectionType = .no
    passwordTextField.autocapitalizationType = .none
    passwordTextField.autocorrectionType = .no
    passwordTextField.isSecureTextEntry = true
    confirmPasswordtextField.autocapitalizationType = .none
    confirmPasswordtextField.autocorrectionType = .no
    confirmPasswordtextField.isSecureTextEntry = true
    
    setupConstraints()
  }
  
  func setupConstraints() {
    
    let emailStackView = UIStackView(
      arrangedSubviews: [emailLabel, emailextField], axis: .vertical, spacing: 10)
    let passwordStackView = UIStackView(
      arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 10)
    let confirmPasswordStackView = UIStackView(
      arrangedSubviews: [confirmPasswordLabel, confirmPasswordtextField], axis: .vertical, spacing: 10)
    
    let stackView = UIStackView(arrangedSubviews: [
      emailStackView, passwordStackView, confirmPasswordStackView, signUpButton
    ], axis: .vertical, spacing: 40)
    
    let bottomStackView = UIStackView(arrangedSubviews: [alreadyWithUsLabel, loginButton],
                                      axis: .horizontal, spacing: 0)
    
    let secondaryView = UIView()
    secondaryView.layer.cornerRadius = 20
    secondaryView.backgroundColor = .secondaryDark
    
    view.addSubview(scrollView)
    scrollView.addSubview(greetingLabel)
    scrollView.addSubview(secondaryView)
    scrollView.addSubview(stackView)
    scrollView.addSubview(bottomStackView)
    
    [scrollView, greetingLabel, stackView, signUpButton, bottomStackView,loginButton, secondaryView].forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      greetingLabel.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 100),
      greetingLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      
      stackView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 150),
      stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
      
      bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 100),
      bottomStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      
      secondaryView.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor, constant: -35),
      secondaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      secondaryView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
      secondaryView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 35),
      
      signUpButton.heightAnchor.constraint(equalToConstant: 60),
      loginButton.widthAnchor.constraint(equalToConstant: 100)
    ])
  }
}

// MARK: - SignUpViewControllerProtocol
extension SignUpViewController: SignUpViewControllerProtocol {
  
}
