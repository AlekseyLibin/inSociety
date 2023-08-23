//
//  ProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import SDWebImage

protocol SendRequestViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?, completion: @escaping () -> Void)
  func showAlert(with title: String, and message: String?)
  func dismiss()
}

final class SendRequestViewController: BaseViewController {
  
  private let scrollView = UIScrollView()
  
  private let sendMessageView = UIView()
  private let imageView = UIImageView()
  private let nameLabel = UILabel()
  private let aboutThemLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let descriptionLabelBackgroundView = UIView()
  private let messageInputView = MessageInputView()
  private let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
  
  private let user: UserModel
  private let configurator: SendRequestConfiguratorProtocol = SendRequestConfigurator()
  var presenter: SendRequestPresenterProtocol!
  
  init(user: UserModel) {
    self.user = user
    
    self.nameLabel.text = user.fullName
    self.descriptionLabel.text = user.description
    self.imageView.sd_setImage(with: URL(string: user.avatarString))
    super.init(nibName: nil, bundle: nil)
    configurator.configure(viewController: self)
    self.fillAboutThemLabel(by: user.sex)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupContentSize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContentSize() {
    scrollView.contentSize = view.frame.size
  }
  
  @objc private func sendButtonPressed() {
    guard
      let message = messageInputView.textField.text,
      !message.isEmpty
    else { return }
    presenter.sendChatRequest(to: user, with: message)
    messageInputView.textField.text = ""
  }
}

// MARK: - Setup views
private extension SendRequestViewController {
  func setupViews() {
    view.backgroundColor = .mainDark()
    
    imageView.layer.cornerRadius = 12
    imageView.layer.borderWidth = 0.4
    imageView.layer.borderColor = UIColor.mainYellow().cgColor
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    
    scrollView.showsVerticalScrollIndicator = false
    scrollView.hideKeyboardWhenTappedOrSwiped()
    
    sendMessageView.layer.cornerRadius = 30
    sendMessageView.backgroundColor = .mainDark()
    
    raiseTextFieldWhenKeyboardOpen()
    
    nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
    nameLabel.textColor = .mainWhite()
    nameLabel.textAlignment = .center
    
    aboutThemLabel.font = .systemFont(ofSize: 10, weight: .light)
    
    descriptionLabelBackgroundView.backgroundColor = .secondaryDark()
    descriptionLabelBackgroundView.layer.cornerRadius = 12
    descriptionLabelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    descriptionLabel.numberOfLines = 2
    descriptionLabel.textColor = .mainWhite()
    descriptionLabel.font = .systemFont(ofSize: 14, weight: .light)
    
    messageInputView.sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
            
    view.addSubview(scrollView)
    scrollView.addSubview(imageView)
    scrollView.addSubview(sendMessageView)
    sendMessageView.addSubview(nameLabel)
    sendMessageView.addSubview(aboutThemLabel)
    sendMessageView.addSubview(descriptionLabelBackgroundView)
    sendMessageView.addSubview(descriptionLabel)
    sendMessageView.addSubview(messageInputView)
    setupConstraints()
  }
  
  func setupConstraints() {
    [scrollView, sendMessageView, imageView, nameLabel, aboutThemLabel, descriptionLabelBackgroundView, descriptionLabel, messageInputView].forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: 30),
      
      sendMessageView.heightAnchor.constraint(equalTo: sendMessageView.widthAnchor, multiplier: 0.5),
      sendMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      sendMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      sendMessageView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
      
      nameLabel.topAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: 15),
      nameLabel.centerXAnchor.constraint(equalTo: sendMessageView.centerXAnchor),
      nameLabel.widthAnchor.constraint(equalTo: sendMessageView.widthAnchor, multiplier: 0.9),
      nameLabel.heightAnchor.constraint(equalToConstant: 30),
      
      aboutThemLabel.bottomAnchor.constraint(equalTo: descriptionLabelBackgroundView.topAnchor, constant: -5),
      aboutThemLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: 5),
      
      descriptionLabelBackgroundView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25),
      descriptionLabelBackgroundView.centerXAnchor.constraint(equalTo: sendMessageView.centerXAnchor),
      descriptionLabelBackgroundView.widthAnchor.constraint(equalTo: sendMessageView.widthAnchor, multiplier: 0.9),
      descriptionLabelBackgroundView.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
      descriptionLabelBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
      
      descriptionLabel.topAnchor.constraint(equalTo: descriptionLabelBackgroundView.topAnchor, constant: 7),
      descriptionLabel.centerXAnchor.constraint(equalTo: descriptionLabelBackgroundView.centerXAnchor),
      descriptionLabel.widthAnchor.constraint(equalTo: descriptionLabelBackgroundView.widthAnchor, multiplier: 0.9),
      descriptionLabel.bottomAnchor.constraint(equalTo: descriptionLabelBackgroundView.bottomAnchor, constant: -7),
      
      messageInputView.heightAnchor.constraint(equalToConstant: 50),
      messageInputView.centerXAnchor.constraint(equalTo: sendMessageView.centerXAnchor),
      messageInputView.widthAnchor.constraint(equalTo: sendMessageView.widthAnchor),
      messageInputView.bottomAnchor.constraint(equalTo: sendMessageView.bottomAnchor, constant: -10)
    ])
  }
  
  private func fillAboutThemLabel(by sex: UserModel.Sex) {
    var text = "About "
    switch sex {
    case .male:
      text += "him"
    case .female:
      text += "her"
    case .other:
      text += "them"
    }
    self.aboutThemLabel.text = text
  }
  
  func raiseTextFieldWhenKeyboardOpen() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
  }
  @objc private func keyboardWillShow(_ notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? .zero
      UIView.animate(withDuration: 0.3) {
        self.messageInputView.transform = CGAffineTransform(translationX: 0,
                                                            y: -keyboardSize.height + bottomPadding + 10)
        self.messageInputView.isBlured(true)
        self.messageInputView.changeButtonType(to: .done)
      }
    }
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    UIView.animate(withDuration: 0.3) {
      self.messageInputView.transform = .identity
      self.messageInputView.isBlured(false)
      self.messageInputView.changeButtonType(to: .send)
    }
  }
}

extension SendRequestViewController: SendRequestViewControllerProtocol {
  
}
