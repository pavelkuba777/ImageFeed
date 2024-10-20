//
//  ProfileTests.swift
//  ImageFeed
//
//  Created by Павел Куба on 20.10.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testProfileLogout() {
        let presenter = ProfilePresenterSpy()
        XCTAssertNotNil(presenter.profile)
        presenter.logout()
        XCTAssertNil(presenter.profile)
    }
}
