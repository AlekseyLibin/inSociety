//
//  UIImage + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 25.10.2022.
//

import UIKit

extension UIImage {
    
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 480
        
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
//        let rect = cropToRect(rect: CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>))
       return scaledImage(to: newImageSize)
    }
    
    func scaledImage(to size: CGSize) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func cropToRect(rect: CGRect!) -> UIImage? {

        let scaledRect = CGRect(x: rect.origin.x * self.scale, y: rect.origin.y * self.scale, width: rect.size.width * self.scale, height: rect.size.height * self.scale);


        guard let imageRef: CGImage = self.cgImage?.cropping(to:scaledRect)
        else {
            return nil
        }

        let croppedImage: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        return croppedImage
    }
}
