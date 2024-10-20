//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Павел Куба on 20.10.2024.
//

import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    func logout() {
        profile = nil
    }

    var profileImageUrl: String?

    var profile: ImageFeed.Profile? = Profile(
        username: "test_username",
        name: "",
        loginName: "",
        bio: ""
    )


}
