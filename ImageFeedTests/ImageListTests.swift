//
//  ImageListTests.swift
//  ImageFeed
//
//  Created by Павел Куба on 20.10.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testfetchPhotos() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter

        presenter.viewDidLoad()
        XCTAssertFalse(viewController.photos.isEmpty)
    }

    func testChangeLikePhoto() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter

        let photoIndex = 0
        presenter.viewDidLoad()
        let isLiked = viewController.photos[photoIndex].isLiked
        presenter.changeLike(photoIndex: photoIndex) { _ in }

        XCTAssertNotEqual(isLiked, viewController.photos[photoIndex].isLiked)
    }
}
