//
//  ViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit
import Lottie
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices

protocol AuthViewControllerProtocol: BaseViewCotrollerProtocol, ASAuthorizationControllerDelegate {
  func showAlert(with title: String, and message: String?, completion: @escaping () -> Void)
  func showAlert(with title: String, and message: String?)
  
  var navigationController: UINavigationController? { get }
  var presenter: AuthPresenterInputProtocol! { get set }
}

final class AuthViewController: BaseViewController {
  
  private let backgroundAnimationView = LottieAnimationView(name: "BackgroundAnimation")
  private let logoImage = UIImageView(named: "inSociety", contentMode: .scaleAspectFit)
  private let emailLabel = UILabel(text: AuthString.getStartedWith.localized)
  private let loginLabel = UILabel(text: AuthString.alreadyOnBoard.localized)
  
  private let googleButton = GoogleButton()
  private let appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .black)
  private let emailButton = CustomButton(title: AuthString.email.localized, titleColor: .black, mainBackgroundColor: .mainYellow)
  private let loginButton = CustomButton(title: AuthString.login.localized, titleColor: .mainYellow)
  
  var presenter: AuthPresenterInputProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let configurator = AuthConfigurator()
    configurator.configure(with: self)
    playBackgroundAnimation()
    setupViews()
    prepareLoadingAnimation()
  }
  
  deinit {
    backgroundAnimationView.stop()
    backgroundAnimationView.removeFromSuperview()
    LottieAnimationCache.shared?.clearCache()
  }
  
  // MARK: - Animations
  /// Plays main background animation
  func playBackgroundAnimation() {
    backgroundAnimationView.frame = view.bounds
    backgroundAnimationView.alpha = 0.4
    backgroundAnimationView.contentMode = .scaleAspectFill
    backgroundAnimationView.loopMode = .autoReverse
    backgroundAnimationView.animationSpeed = 0.2
    view.addSubview(backgroundAnimationView)
    backgroundAnimationView.play()
  }
}

private extension AuthViewController {
  func setupViews() {
    view.backgroundColor = .mainDark
    logoImage.setupColor(.mainYellow)
    emailButton.addBaseShadow()
    
    loginButton.layer.borderColor = UIColor.mainYellow.cgColor
    loginButton.addBaseShadow()
    loginButton.layer.borderWidth = 2
    
    appleButton.cornerRadius = 10
    
    emailLabel.textColor = .lightGray
    loginLabel.textColor = .lightGray
    
    emailButton.addTarget(self, action: #selector(emailButtonPressed), for: .touchUpInside)
    loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
    appleButton.addTarget(self, action: #selector(appleButtonPressed), for: .touchUpInside)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    
    let orView = UIView()
    let orLabel = UILabel(text: AuthString.orLabel.localized)
    orLabel.textColor = .lightGray
    orLabel.translatesAutoresizingMaskIntoConstraints = false
    orView.addSubview(orLabel)
    
    let leftline = UIView()
    leftline.backgroundColor = .lightGray
    leftline.translatesAutoresizingMaskIntoConstraints = false
    orView.addSubview(leftline)
    
    let rightLine = UIView()
    rightLine.backgroundColor = .lightGray
    rightLine.translatesAutoresizingMaskIntoConstraints = false
    orView.addSubview(rightLine)
    
    NSLayoutConstraint.activate([
      leftline.leadingAnchor.constraint(equalTo: orView.leadingAnchor),
      leftline.trailingAnchor.constraint(equalTo: orLabel.leadingAnchor, constant: -15),
      leftline.heightAnchor.constraint(equalToConstant: 1),
      leftline.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
      
      orLabel.centerYAnchor.constraint(equalTo: orView.centerYAnchor),
      orLabel.centerXAnchor.constraint(equalTo: orView.centerXAnchor),
      
      rightLine.trailingAnchor.constraint(equalTo: orView.trailingAnchor),
      rightLine.leadingAnchor.constraint(equalTo: orLabel.trailingAnchor, constant: 15),
      rightLine.heightAnchor.constraint(equalToConstant: 1),
      rightLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
    ])
    
    let googleAppleStackView = UIStackView(arrangedSubviews: [googleButton, appleButton], axis: .vertical, spacing: 10)
    let emailView = LabelButtonView(label: emailLabel, button: emailButton)
    let loginView = LabelButtonView(label: loginLabel, button: loginButton)
    
    let stackView = UIStackView(arrangedSubviews: [emailView, loginView, orView, googleAppleStackView],
                                axis: .vertical, spacing: 30)
    
    [logoImage, stackView].forEach { subView in
      view.addSubview(subView)
      subView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
      logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
      logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 0.34),
      
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.frame.width * 0.1),
      
      googleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
      googleButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12),
      googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      appleButton.widthAnchor.constraint(equalTo: googleButton.widthAnchor),
      appleButton.heightAnchor.constraint(equalTo: googleButton.heightAnchor),
      appleButton.centerXAnchor.constraint(equalTo: googleButton.centerXAnchor)
    ])
  }
  
  // MARK: - Actions
  @objc func emailButtonPressed() {
    presenter.emailButtonPressed()
  }
  
  @objc func loginButtonPressed() {
    presenter.loginButtonPressed()
  }
  
  @objc func googleButtonPressed() {
    AuthService.shared.enter(self) { [weak self] result in
      self?.presenter.signInWithGoogle(with: result)
    }
  }
  
  @objc func appleButtonPressed() {
    presenter.appleButtonPressed()
  }
}

extension AuthViewController: AuthViewControllerProtocol { }

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}

// MARK: - AuthViewControllerProtocol
extension AuthViewController {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    presenter.didCompleteWithAuthorization(authorization)
  }
}
