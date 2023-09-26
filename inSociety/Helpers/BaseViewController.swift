//
//  BaseViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 01.12.2022.
//

import UIKit
import Lottie

protocol BaseViewCotrollerProtocol: AnyObject {
  /// Presents UIViewController modally
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
  /// Closes modally presented UIViewController
  func dismiss(animated flag: Bool, completion: (() -> Void)?)
  /// Generates haptic feedback with certain type
  func generateHapticFeedback(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType)
  /// Prepares loading animation to be presented
  func prepareLoadingAnimation()
  /// Plays loading animation
  func playLoadingAnimation()
  /// Stops loading animation
  func stopLoadingAnimation()
}

class BaseViewController: UIViewController {
  
  private let feedbackGenerator: UINotificationFeedbackGenerator
  private let loadingAnimationView: LottieAnimationView
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    feedbackGenerator = UINotificationFeedbackGenerator()
    loadingAnimationView = LottieAnimationView(name: "LoadingAnimation")
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    print(" - init \(String(describing: type(of: self)))")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print(" - deinit \(String(describing: type(of: self)))")
  }
}

extension BaseViewController: BaseViewCotrollerProtocol {
  
  func generateHapticFeedback(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
    feedbackGenerator.notificationOccurred(feedbackType)
  }
  
  func prepareLoadingAnimation() {
    loadingAnimationView.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.7,
                                                    height: view.frame.height * 0.7)
    loadingAnimationView.center = view.center
    loadingAnimationView.isUserInteractionEnabled = false
    loadingAnimationView.contentMode = .scaleAspectFit
    loadingAnimationView.loopMode = .autoReverse
    loadingAnimationView.animationSpeed = 3
  }
  
  func playLoadingAnimation() {
    view.addSubview(loadingAnimationView)
    loadingAnimationView.play()
  }
  
  func stopLoadingAnimation() {
    loadingAnimationView.stop()
    loadingAnimationView.removeFromSuperview()
    LottieAnimationCache.shared?.clearCache()
  }
}
    
