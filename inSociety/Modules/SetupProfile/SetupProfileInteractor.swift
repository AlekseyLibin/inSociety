//
//  SetupProfileInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import UIKit

protocol SetupProfileInteractorProtocol {
    func submitButtonPressed(userName: String?,
                             avatarImage: UIImage?,
                             email: String,
                             description: String?,
                             sex: String?,
                             id: String,
                             completion: @escaping (Result<UserModel, Error>) -> Void)
}

final class SetupProfileInteractor {
    
}

extension SetupProfileInteractor: SetupProfileInteractorProtocol {
    func submitButtonPressed(userName: String?, avatarImage: UIImage?, email: String, description: String?, sex: String?, id: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        FirestoreService.shared.saveProfileWith(userName: userName,
                                                avatarImage: avatarImage,
                                                email: email,
                                                description: description,
                                                sex: sex,
                                                id: id) { result in
            switch result {
            case .success(let currentUserModel):
                completion(.success(currentUserModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
}
