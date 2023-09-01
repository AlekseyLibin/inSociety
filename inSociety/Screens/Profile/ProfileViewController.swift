//
//  ProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 01.11.2022.
//

import UIKit
import SDWebImage
import FirebaseAuth

protocol ProfileViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?)
  func updateViews(with userModel: UserModel)
  func activeChats(changeQuantity count: Int)
  func waitingChats(changeQuantity count: Int)
  var currentUser: UserModel { get }
}

final class ProfileViewController: BaseViewController {
  
  let currentUser: UserModel
  
  private let avatarView = UIImageView()
  private let fullNameLabel = UILabel()
  private let aboutMeLabel = UILabel()
  private let activeChatsNumberLabel = UILabel(text: ProfileString.activeChats.localized)
  private let waitingChatsNumberLabel = UILabel(text: ProfileString.waitingChats.localized)
  private let editButton = UIButton(title: ProfileString.edit.localized, titleColor: .systemBlue, backgroundColor: .secondaryDark)
  private let logOutButton = UIButton(title: ProfileString.logOut.localized, titleColor: .systemRed, backgroundColor: .secondaryDark)
  private let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
  var presenter: ProfilePresenterProtocol!
  
  init(currentUser: UserModel) {
    self.currentUser = currentUser
    super.init(nibName: nil, bundle: nil)
    configurator.configure(viewController: self)
    setupTopBar()
    setupViews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.fillUpActualInformation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presenter.fillUpActualInformation()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup Views
private extension ProfileViewController {
  func setupViews() {
    view.backgroundColor = .mainDark
    tabBarController?.tabBar.backgroundColor = .mainDark
    presenter.fillChatsInformation(by: currentUser)
    
    editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
    logOutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
    
    avatarView.sd_setImage(with: URL(string: currentUser.avatarString))
    avatarView.clipsToBounds = true
    avatarView.layer.masksToBounds = true
    avatarView.layer.cornerRadius = 15
    avatarView.contentMode = .scaleAspectFill
    
    fullNameLabel.text = currentUser.fullName
    fullNameLabel.font = .light25
    fullNameLabel.textColor = .mainYellow

    aboutMeLabel.text = currentUser.description
    aboutMeLabel.numberOfLines = 2
    aboutMeLabel.font = .systemFont(ofSize: 12, weight: .light)
    aboutMeLabel.textColor = .mainYellow
    
    activeChatsNumberLabel.font = .light25
    activeChatsNumberLabel.textColor = .mainYellow
    
    waitingChatsNumberLabel.font = .light25
    waitingChatsNumberLabel.textColor = .mainYellow
    
    setupConstraints()
  }
  
  @objc func editButtonPressed() {
    presenter.editButtonPressed()
  }
  
  @objc private func logOutButtonPressed() {
    presenter.logOutButtonPressed()
  }
  
  func setupTopBar() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .mainDark
    
    let titleLabel = UILabel(text: ProfileString.profile.localized)
    titleLabel.font = .systemFont(ofSize: 23)
    titleLabel.textColor = .systemGray
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationItem.titleView = titleLabel
  }
  
  func setupConstraints() {
    
    let avatarBackgroudView = UIView()
    avatarBackgroudView.layer.cornerRadius = 15
    avatarBackgroudView.backgroundColor = .secondaryDark
    
    let aboutMeLabelBackgroundView = UIView()
    aboutMeLabelBackgroundView.layer.cornerRadius = 15
    aboutMeLabelBackgroundView.backgroundColor = .mainDark
    
    avatarBackgroudView.addSubview(avatarView)
    avatarBackgroudView.addSubview(fullNameLabel)
    avatarBackgroudView.addSubview(aboutMeLabelBackgroundView)
    avatarBackgroudView.addSubview(aboutMeLabel)
    
    avatarBackgroudView.translatesAutoresizingMaskIntoConstraints = false
    avatarView.translatesAutoresizingMaskIntoConstraints = false
    fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
    aboutMeLabelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(avatarBackgroudView)
    
    let chatsInformationStackView = UIStackView(arrangedSubviews: [activeChatsNumberLabel, waitingChatsNumberLabel])
    chatsInformationStackView.backgroundColor = .secondaryDark
    chatsInformationStackView.layer.cornerRadius = 20
    chatsInformationStackView.axis = .vertical
    chatsInformationStackView.distribution = .fillEqually
    activeChatsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    waitingChatsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    chatsInformationStackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(chatsInformationStackView)
    
    editButton.translatesAutoresizingMaskIntoConstraints = false
    editButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .light)
    view.addSubview(editButton)
    
    logOutButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(logOutButton)
    
    fullNameLabel.backgroundColor = .red
    aboutMeLabel.backgroundColor = .green
    
    NSLayoutConstraint.activate([
      avatarBackgroudView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      avatarBackgroudView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
      avatarBackgroudView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      avatarBackgroudView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
      
      avatarView.topAnchor.constraint(equalTo: avatarBackgroudView.topAnchor, constant: 10),
      avatarView.leadingAnchor.constraint(equalTo: avatarBackgroudView.leadingAnchor, constant: 10),
      avatarView.bottomAnchor.constraint(equalTo: avatarBackgroudView.bottomAnchor, constant: -10),
      avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor, multiplier: 1),
      
      fullNameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor),
      fullNameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20),
      fullNameLabel.trailingAnchor.constraint(equalTo: avatarBackgroudView.trailingAnchor, constant: -20),
      
      aboutMeLabelBackgroundView.widthAnchor.constraint(equalTo: aboutMeLabel.widthAnchor, constant: 20),
      aboutMeLabelBackgroundView.heightAnchor.constraint(equalTo: aboutMeLabel.heightAnchor, constant: 20),
      aboutMeLabelBackgroundView.centerXAnchor.constraint(equalTo: aboutMeLabel.centerXAnchor),
      aboutMeLabelBackgroundView.centerYAnchor.constraint(equalTo: aboutMeLabel.centerYAnchor),

      aboutMeLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 15),
      aboutMeLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20),
      aboutMeLabel.trailingAnchor.constraint(equalTo: avatarBackgroudView.trailingAnchor, constant: -20),
      aboutMeLabel.bottomAnchor.constraint(equalTo: avatarBackgroudView.bottomAnchor, constant: -15),
      
      editButton.topAnchor.constraint(equalTo: avatarBackgroudView.bottomAnchor, constant: 20),
      editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      editButton.widthAnchor.constraint(equalTo: avatarBackgroudView.widthAnchor),
      editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor, multiplier: 0.125),
      
      chatsInformationStackView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 50),
      chatsInformationStackView.leadingAnchor.constraint(equalTo: avatarBackgroudView.leadingAnchor),
      chatsInformationStackView.trailingAnchor.constraint(equalTo: avatarBackgroudView.trailingAnchor),
      chatsInformationStackView.heightAnchor.constraint(equalTo: avatarBackgroudView.heightAnchor, multiplier: 1.2),
      activeChatsNumberLabel.leadingAnchor.constraint(equalTo: chatsInformationStackView.leadingAnchor, constant: 20),
      
      logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logOutButton.widthAnchor.constraint(equalTo: avatarBackgroudView.widthAnchor),
      logOutButton.heightAnchor.constraint(equalTo: logOutButton.widthAnchor, multiplier: 0.15)
    ])
  }
}

extension ProfileViewController: ProfileViewControllerProtocol {
  func updateViews(with userModel: UserModel) {
    let userImageURL = URL(string: userModel.avatarString)
    avatarView.sd_setImage(with: userImageURL)
    
    fullNameLabel.text = userModel.fullName
    aboutMeLabel.text = userModel.description
  }
  
  func activeChats(changeQuantity count: Int) {
    self.activeChatsNumberLabel.text = "\(ProfileString.activeChats.localized): \(count.description)"
  }
  
  func waitingChats(changeQuantity count: Int) {
    self.waitingChatsNumberLabel.text = "\(ProfileString.waitingChats.localized): \(count.description)"
  }
}
