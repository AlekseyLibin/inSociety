//
//  SetupProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

class SetupProfileViewController: UIViewController {
    
    let fillImageView = AddPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
    }
}



//MARK: - Setup constraints
extension SetupProfileViewController {
    func setupConstraints() {
        
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fillImageView)
        
        NSLayoutConstraint.activate([
            fillImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            fillImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
