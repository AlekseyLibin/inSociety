//
//  SetupProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

class SetupProfileViewController: UIViewController {
    
    let fillImageView = AddPhotoView()
    
    let setupLabel = UILabel(text: "Setup profile", font: .galvji30())
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = UnderlinedTextField(font: .galvji20())
    let aboutMeTextField = UnderlinedTextField(font: .galvji20())
    
    let sexSegmentedControl = UISegmentedControl(elements: ["Male", "Female", "Other"])
    let submitButton = UIButton(title: "Submit",
                              titleColor: .white, backgroundColor: .darkButtonColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
    }
}



//MARK: - Setup constraints
extension SetupProfileViewController {
    private func setupConstraints() {
        
        view.addSubview(setupLabel)
        view.addSubview(fillImageView)
        
        setupLabel.translatesAutoresizingMaskIntoConstraints = false
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            setupLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            setupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            fillImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            fillImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let fullNameStackview = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField],
                                            axis: .vertical, spacing: 10)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField],
                                           axis: .vertical, spacing: 10)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl],
                                       axis: .vertical, spacing: 15)
        
        let stackView = UIStackView(arrangedSubviews: [fullNameStackview, aboutMeStackView, sexStackView, submitButton],
                                    axis: .vertical, spacing: 50)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
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
        let setupProfileViewController = SetupProfileViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return setupProfileViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
