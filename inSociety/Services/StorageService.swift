//
//  StorageService.swift
//  inSociety
//
//  Created by Aleksey Libin on 25.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

final class StorageService {
  
  static let shared = StorageService()
  private init() {}
  
  private let storageRef = Storage.storage().reference()
  private var avatarsRef: StorageReference {
    return storageRef.child("avatars")
  }
  
  /// uploads image for current user
  func image(upload image: UIImage, path email: String, completion: @escaping(Result<URL, Error>) -> Void) {
    guard
      let scaledImage = image.scaledToSafeUploadSize,
      let imageData = scaledImage.jpegData(compressionQuality: 0.4)
    else { return }
    
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    
    avatarsRef.child(email).putData(imageData,
                                              metadata: metadata) { [weak self] metadata, error in
      guard let self = self else { return }
      
      guard metadata != nil else {
        completion(.failure(error!))
        return
      }
      
      self.avatarsRef.child(email).downloadURL { url, error in
        guard let downloadedUrl = url else {
          completion(.failure(error!))
          return
        }
        
        completion(.success(downloadedUrl))
      }
    }
  }
  
  /// removes current user's avatar from database
  func image(delete user: User, failureCompletion: @escaping (Error?) -> Void) {
    guard let currentUserPath = user.email else { return }
    avatarsRef.delete(completion: failureCompletion)
  }
}
