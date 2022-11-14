//
//  StorageService.swift
//  inSociety
//
//  Created by Aleksey Libin on 25.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {
    
    static let shared = StorageService()
    private init() {}
    
    let storageRef = Storage.storage().reference()
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    private var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    func upload(image: UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        
        guard
            let scaledImage = image.scaledToSafeUploadSize,
            let imageData = scaledImage.jpegData(compressionQuality: 0.4)
        else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let currentUserId = currentUserId else { return }
        avatarsRef.child(currentUserId).putData(imageData,
                                                metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            self.avatarsRef.child(currentUserId).downloadURL { url, error in
                guard let downloadedUrl = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(downloadedUrl))
            }
        }
        
    }
}
