//
//  ProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import SDWebImage

protocol SendRequestViewControllerProtocol: AnyObject {
  func showAlert(with title: String, and message: String?)
  func dismiss()
  func removeActivityIndicator()
}

final class SendRequestViewController: BaseViewController {
  
  private let scrollView = UIScrollView()
  
  private let containerView = UIView()
  private let imageView = UIImageView()
  private let nameLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let sendMessageTextField = SendMessageTextField()
  private let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

  
  private let user: UserModel
  private let configurator: SendRequestConfiguratorProtocol = SendRequestConfigurator()
  var presenter: SendRequestPresenterProtocol!
  
  init(user: UserModel) {
    self.user = user
    
    self.nameLabel.text = user.userName
    self.descriptionLabel.text = user.description
    self.imageView.sd_setImage(with: URL(string: user.userAvatarString))
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurator.configure(viewController: self)
    setupViews()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    scrollView.contentSize = view.frame.size
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func sendButtonPressed() {
    guard
      let message = sendMessageTextField.text,
      !message.isEmpty
    else { return }
    sendMessageTextField.text = ""
    
    scrollView.addSubview(activityIndicator)
    activityIndicator.center = scrollView.center
    activityIndicator.startAnimating()
    
    presenter.sendChatRequest(to: user, with: message)
  }
}


//MARK: - Setup views
private extension SendRequestViewController {
  func setupViews() {
    
    view.backgroundColor = .white
    
    imageView.contentMode = .scaleAspectFill
    
    scrollView.hideKeyboardWhenTappedOrSwiped()
    scrollView.addKeyboardObservers()
    scrollView.contentSize.height = view.frame.height/1.07   //On a modally presented VC height is different
    scrollView.contentSize.width = view.frame.width
    
    containerView.layer.cornerRadius = 30
    containerView.backgroundColor = .mainDark()
    
    nameLabel.font = .systemFont(ofSize: 20, weight: .light)
    nameLabel.textColor = .mainWhite()
    
    descriptionLabel.numberOfLines = 2
    descriptionLabel.textColor = .mainWhite()
    descriptionLabel.font = .systemFont(ofSize: 16, weight: .light)
    
    if let button = sendMessageTextField.rightView as? UIButton {
      button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    view.addSubview(imageView)
    view.addSubview(scrollView)
    scrollView.addSubview(containerView)
    containerView.addSubview(nameLabel)
    containerView.addSubview(descriptionLabel)
    containerView.addSubview(sendMessageTextField)
    
    setupConstraints()
  }
  
  
  func setupConstraints() {
    
    [scrollView, containerView, imageView, nameLabel, descriptionLabel, sendMessageTextField].forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      containerView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/1.07),
      containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      containerView.heightAnchor.constraint(equalToConstant: 210),
      
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      nameLabel.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 35),
      nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      
      descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
      descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      descriptionLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
      
      sendMessageTextField.heightAnchor.constraint(equalToConstant: 50),
      sendMessageTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      sendMessageTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
      sendMessageTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
    ])
  }
}


extension SendRequestViewController: SendRequestViewControllerProtocol {
  func removeActivityIndicator() {
    activityIndicator.removeFromSuperview()
  }
  
}
