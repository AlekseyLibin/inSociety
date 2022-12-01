//
//  SetupProfilePresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import UIKit

protocol SetupProfilePresenterProtocol: AnyObject {
    func submitButtonPressed(userName: String?,
                             avatarImage: UIImage?,
                             email: String,
                             description: String?,
                             sex: String?,
                             id: String)
}

final class SetupProfilePresenter {
    
    private weak var viewController: SetupProfileViewControllerProtocol!
    var interactor: SetupProfileInteractorProtocol!
    var router: SetupProfileRouterProtocol!
    
    init(viewController: SetupProfileViewControllerProtocol) {
        self.viewController = viewController
    }
    
}

extension SetupProfilePresenter: SetupProfilePresenterProtocol {
    func submitButtonPressed(userName: String?, avatarImage: UIImage?, email: String, description: String?, sex: String?, id: String) {
        interactor.submitButtonPressed(userName: userName, avatarImage: avatarImage, email: email, description: description, sex: sex, id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let currentUserModel):
                self.router.toMainVC(currentUser: currentUserModel)
            case .failure(let error):
                self.viewController.showAlert(with: "Error", and: error.localizedDescription, completion: {})
            }
        }
    }
    
    
}
