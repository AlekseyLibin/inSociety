//
//  SetupProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

class SetupProfileViewController: UIViewController {
    
    let fillImageView = AddPhotoView()
    
    let scrollView = UIScrollView()
    
    let setupLabel = UILabel(text: "Setup profile", font: .galvji30())
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = UnderlinedTextField(font: .galvji20())
    let aboutMeTextField = UnderlinedTextField(font: .galvji20())
    
    let sexSegmentedControl = UISegmentedControl(elements: ["Male", "Female", "Other"])
    let submitButton = UIButton(title: "Submit",
                              titleColor: .white, backgroundColor: .darkButtonColor())
    
    private let currentUser: User
    
    
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let name = currentUser.displayName {
            fullNameTextField.text = name
        }
        if let photoUrl = currentUser.photoURL {
            fillImageView.profileImageView.sd_setImage(with: photoUrl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        fillImageView.addProfilePhoto.addTarget(self, action: #selector(addProfilePhoto), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        scrollView.contentSize = view.frame.size
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Buttons realization
extension SetupProfileViewController {
    @objc private func addProfilePhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @objc private func submitButtonPressed() {
        FirestoreService.shared.saveProfileWith(userName: fullNameTextField.text,
                                                avatarImage: fillImageView.profileImageView.image,
                                                email: currentUser.email ?? "no email",
                                                description: aboutMeTextField.text,
    sex: sexSegmentedControl.titleForSegment(at:sexSegmentedControl.selectedSegmentIndex),
                                                id: currentUser.uid) { result in
            switch result {
            case .success(let currentUser):
                self.showAlert(with: "Success", and: "") {
                    let mainTabBar = MainTabBarController(currentUser: currentUser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.present(mainTabBar, animated: true)
                }
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
}




//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        fillImageView.profileImageView.image = image
        
    }
}



//MARK: - Setup views
extension SetupProfileViewController {
    private func setupViews() {
        
        view.backgroundColor = .mainWhite()
        
        scrollView.addKeyboardObservers()
        scrollView.hideKeyboardWhenTappedOrSwiped()
        scrollView.showsVerticalScrollIndicator = false
        
        fullNameTextField.autocapitalizationType = .none
        aboutMeTextField.autocapitalizationType = .none
        
        
        
        let fullNameStackview = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField],
                                            axis: .vertical, spacing: 10)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField],
                                           axis: .vertical, spacing: 10)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl],
                                       axis: .vertical, spacing: 15)
        
        let stackView = UIStackView(arrangedSubviews: [fullNameStackview, aboutMeStackView, sexStackView, submitButton],
                                    axis: .vertical, spacing: 50)
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(setupLabel)
        scrollView.addSubview(fillImageView)
        scrollView.addSubview(stackView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        setupLabel.translatesAutoresizingMaskIntoConstraints = false
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            setupLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            setupLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            fillImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 200),
            fillImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            
            submitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
}



//MARK: - SwiftUI
import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let setupProfileViewController = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return setupProfileViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
