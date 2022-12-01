//
//  AuthInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth

protocol AuthInteractorProtocol: AnyObject {
    func checkIfRegestrationCompleted(completion: @escaping (Result<UserModel, Error>) -> Void)
}

final class AuthInteractor {
        
}


extension AuthInteractor: AuthInteractorProtocol {
    
    func checkIfRegestrationCompleted(completion: @escaping (Result<UserModel, Error>) -> Void) {
        FirestoreService.shared.getDataForCurrentUser { result in
            
            switch result {
            case .success(let currentCompletedUser):
                completion(.success(currentCompletedUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
