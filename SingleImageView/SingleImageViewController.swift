//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Павел Куба on 22.06.2024.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Public properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            guard let image else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
      super.viewDidLoad()
      imageView.image = image
      setupScrollView()
      guard let image else { return }
      rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - Actions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton() {
        guard let image else { return }
        let imageToShare = [ image ]
        let shareViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = self.view
        self.present(shareViewController, animated: true)
    }
}


// MARK: - Private methods
private extension SingleImageViewController {
    func setupScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 7.5
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let scaleImageMin = scrollView.minimumZoomScale
        let scaleImageMax = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        let visibleContentSize = scrollView.bounds.size
        let imageSize = image.size
        let scaleHeight = visibleContentSize.height / imageSize.height
        let scaleWidth = visibleContentSize.width / imageSize.width
        let scaleImageTemp = max(scaleWidth, scaleHeight)
        let scaleImage = min(scaleImageMax, max(scaleImageMin, scaleImageTemp))
        scrollView.setZoomScale(scaleImage, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let imageOffsetX = (newContentSize.width - visibleContentSize.width) / 2
        let imageOffsetY = (newContentSize.height - visibleContentSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: imageOffsetX, y: imageOffsetY), animated: false)
        scrollView.layoutIfNeeded()
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
