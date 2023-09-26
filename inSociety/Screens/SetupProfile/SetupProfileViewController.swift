//
//  SetupProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

protocol SetupProfileViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?, completion: @escaping () -> Void)
  func updateViews(with userModel: UserModel)
  var target: SetupProfileViewController.Target { get }
}

final class SetupProfileViewController: BaseViewController {
  
  enum Target {
    case create(firebaseUser: User, appleIdUserName: String? = "")
    case modify(currentUserModel: UserModel)
  }
  
  /// Indicates whether it has to be presented ProfileViewController(modify case) or MainViewController(create case) after setting up profile
  let target: Target
  
  private let fillImageView = FillImageView()
  private var profileImageUrl: URL?
  private let scrollView = UIScrollView()
  private let imagePickerController = UIImagePickerController()
  private let setupView = UIView()
  private let fullNameLabel = UILabel(text: SetupProfileString.fullName.localized)
  private let aboutMeLabel = UILabel(text: SetupProfileString.aboutMe.localized)
  private let sexLabel = UILabel(text: SetupProfileString.sex.localized)
  private let fullNameTextField = UnderlinedTextField(font: .light20)
  private let aboutMeTextField = UnderlinedTextField(font: .light20)
  private let sexSegmentedControl = SexSegmentedControl()
  private let submitButton = CustomButton(title: SetupProfileString.confirm.localized, titleColor: .white,
                                          mainBackgroundColor: .mainDark)
  private var updatingUser: SetupNewUser
  
  var presenter: SetupProfilePresenterProtocol!
  private let configurator: SetupProfileConfiguratorProtocol = SetupProfileConfigurator()
  
  init(target: SetupProfileViewController.Target) {
    self.target = target
    switch target {
    case .create(let firebaseUser, let appleIdUserName):
      self.profileImageUrl = firebaseUser.photoURL
      self.updatingUser = SetupNewUser(name: firebaseUser.displayName ?? appleIdUserName,
                                       avatarImage: nil,
                                       email: firebaseUser.email ?? "no email",
                                       aboutMe: "",
                                       sex: nil,
                                       id: firebaseUser.uid)
    case .modify(let currentUserModel):
      self.profileImageUrl = URL(string: currentUserModel.avatarString)
      self.updatingUser = SetupNewUser(name: currentUserModel.fullName,
                                       avatarImage: nil,
                                       email: currentUserModel.email,
                                       aboutMe: currentUserModel.description,
                                       sex: currentUserModel.sex,
                                       id: currentUserModel.id)
    }
    super.init(nibName: nil, bundle: nil)
    configurator.configure(viewController: self)
    presenter.fillAvailableDataForCurrentUser(by: target)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpNavigationBar()
    setupViews()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupContentSize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContentSize() {
    let setupViewHeight = setupView.frame.height
    scrollView.contentSize = CGSize(width: view.frame.width, height: setupViewHeight + 50)
  }
  
  @objc private func addProfilePhoto() {
    present(imagePickerController, animated: true)
  }
  
  @objc private func submitButtonPressed() {
    updatingUser.name = fullNameTextField.text
    updatingUser.avatarImage = fillImageView.profileImage
    updatingUser.aboutMe = aboutMeTextField.text
    updatingUser.sex = sexSegmentedControl.selectedSex
    presenter.submitButtonPressed(with: updatingUser)
  }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    picker.dismiss(animated: true)
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
    fillImageView.setProfileImage(by: image)
  }
}

// MARK: - Setup views
private extension SetupProfileViewController {
  func setupViews() {
    view.backgroundColor = .mainDark
    
    imagePickerController.delegate = self
    imagePickerController.sourceType = .photoLibrary
    
    scrollView.showsVerticalScrollIndicator = false
    scrollView.delaysContentTouches = false
    scrollView.addKeyboardObservers(with: tabBarController?.tabBar.frame.height ?? 0.0)
    scrollView.hideKeyboardWhenTappedOrSwiped()
    
    submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
    submitButton.setTitleColor(.mainYellow, for: .normal)
    
    fillImageView.setProfileImage(by: profileImageUrl)
    fillImageView.buttonPressed(target: self, action:  #selector(addProfilePhoto), for: .touchUpInside)
    
    [fullNameLabel, aboutMeLabel, sexLabel].forEach { label in
      label.textColor = .mainYellow
    }
    
    fullNameTextField.autocapitalizationType = .none
    fullNameTextField.autocorrectionType = .no
    fullNameTextField.text = updatingUser.name ?? ""
    
    aboutMeTextField.autocapitalizationType = .none
    aboutMeTextField.autocorrectionType = .no
    aboutMeTextField.text = updatingUser.aboutMe ?? ""
    aboutMeTextField.placeholder = SetupProfileString.aboutMePlaceholder.localized
    
    if let updatingUserSex = updatingUser.sex { sexSegmentedControl.selectSex(updatingUserSex) }
    
    setupConstraints()
  }
  
  func setUpNavigationBar() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .mainDark
    
    let titleLabel = UILabel(text: SetupProfileString.setupProfile.localized)
    titleLabel.font = .systemFont(ofSize: 20)
    titleLabel.textColor = .systemGray
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.tintColor = .mainYellow
    navigationItem.titleView = titleLabel
  }
  
  func setupConstraints() {
    let fullNameStackview = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField],
                                        axis: .vertical, spacing: 10)
    let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField],
                                       axis: .vertical, spacing: 10)
    let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl],
                                   axis: .vertical, spacing: 15)
    let stackView = UIStackView(arrangedSubviews: [fullNameStackview, aboutMeStackView, sexStackView, submitButton],
                                axis: .vertical, spacing: 60)
    
    setupView.layer.cornerRadius = 20
    setupView.backgroundColor = .secondaryDark
    
    view.addSubview(scrollView)
    scrollView.addSubview(setupView)
    scrollView.addSubview(fillImageView)
    scrollView.addSubview(stackView)
    
    [scrollView, setupView,
     fillImageView,
     stackView
    ].forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      setupView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
      setupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      setupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      setupView.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 25),
      
      fillImageView.topAnchor.constraint(equalTo: setupView.topAnchor, constant: 40),
      fillImageView.centerXAnchor.constraint(equalTo: setupView.centerXAnchor),
      
      stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 40),
      stackView.leadingAnchor.constraint(equalTo: setupView.leadingAnchor, constant: 25),
      stackView.trailingAnchor.constraint(equalTo: setupView.trailingAnchor, constant: -25),
      
      submitButton.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
}

// MARK: - SetupProfileViewControllerProtocol
extension SetupProfileViewController: SetupProfileViewControllerProtocol {
  func updateViews(with userModel: UserModel) {
    let userImageURL = URL(string: userModel.avatarString)
    let newImageView = UIImageView()
    newImageView.sd_setImage(with: userImageURL)
    guard let image = newImageView.image else { return }
    fillImageView.setProfileImage(by: image)
    
    fullNameTextField.text = userModel.fullName
    aboutMeTextField.text = userModel.description
    sexSegmentedControl.selectedSegmentIndex = UserModel.Sex.allCases.firstIndex(of: userModel.sex) ?? 2
  }
  
  func updateViews(with user: User) {
    let userImageURL = user.photoURL
    UIImageView().sd_setImage(with: user.photoURL) { [weak self] image, _, _, _ in
      self?.fillImageView.setProfileImage(by: image)
    }
    
    fullNameTextField.text = user.displayName
    aboutMeTextField.text = ""
  }
}
