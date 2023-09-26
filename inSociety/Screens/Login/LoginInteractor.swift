//
//  LoginInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

protocol LoginInteractorProtocol {
    func checkIfRegestrationCompleted(completion: @escaping (Result<UserModel, Error>) -> Void)
}

final class LoginInteractor {
    
}

extension LoginInteractor: LoginInteractorProtocol {
    
    func checkIfRegestrationCompleted(completion: @escaping (Result<UserModel, Error>) -> Void) {
        FirestoreService.shared.getCurrentUserModel { result in
            
            switch result {
            case .success(let currentCompletedUser):
                completion(.success(currentCompletedUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
