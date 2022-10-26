//
//  ViewController.swift
//  image
//
//  Created by Aleksey Libin on 26.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 100, width: 400, height: 600)
//        imageView.image = UIImage().ciImage?.cropped(to: <#T##CGRect#>)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Screenshot")?.cropToRect(rect: CGRect(x: imageView.center.x, y: imageView.center.y, width: 400, height: 400))
        view.addSubview(imageView)

    }
    
    


}

extension UIImage {
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

//extension UIImage {
//    // Crops an input image (self) to a specified rect
//    func cropToRect1(rect: CGRect!) -> UIImage? {
//        // Correct rect size based on the device screen scale
//        let scaledRect = CGRectMake(rect.origin.x * self.scale, rect.origin.y * self.scale, rect.size.width * self.scale, rect.size.height * self.scale);
//        // New CGImage reference based on the input image (self) and the specified rect
//        let imageRef = CGImageCreateWithImageInRect(self.CGImage, scaledRect);
//        // Gets an UIImage from the CGImage
//        let result = UIImage(CGImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
//        // Returns the final image, or NULL on error
//        return result;
//    }
//}
//
//// Crops an image to 100x100 pixels, 150px from left and 200px from top
//let exampleImage = UIImage(named: "yourImageFile")
//let croppedImage = exampleImage?.cropToRect(CGRectMake(150.0, 200.0, 100.0, 100.0))
//if croppedImage != nil {
//    // Your image was cropped
//} else {
//    // Something went wrong
//}

