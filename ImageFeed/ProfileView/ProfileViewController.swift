//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Павел Куба on 25.05.2024.
//

import UIKit
import WebKit
import Kingfisher


final class ProfileViewController: UIViewController {
    private let storage = OAuth2TokenStorage()
    private let alertPresenter = AlertPresenter()
    private let profilePhotoImage = UIImageView()
    private let profileFullNameLabel = UILabel()
    private let profileLoginNameLabel = UILabel()
    private let profileDescLabel = UILabel()
    private var exitButton = UIButton(type: .custom)
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        view.backgroundColor = UIColor(resource: .ypBlack)
        setupProfilePhotoImage()
        setupProfileFullNameLabel()
        setupProfileLoginNameLabel()
        setupProfileBioLabel()
        setupProfileExitButton()
        updateProfileDetails(profile: profileService.profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateProfileImage()
        }
        updateProfileImage()
    }
    
    
    private func updateProfileImage() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return }
        profilePhotoImage.kf.setImage(
            with: url,
            placeholder: UIImage(resource: .photo)
        ) { result in
            switch result {
            case .success(let value):
                break
            case .failure(let error):
                print("\(#file):\(#function): Image loading error \(error)")
            }
        }
    }
    
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile
        else {
            print("\(#file):\(#function): Can not update profile info")
            return
        }
        profileFullNameLabel.text = profile.name
        profileLoginNameLabel.text = profile.loginName
        profileDescLabel.text = profile.bio
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func didTapLogoutButton() {
        alertPresenter.showAlert(alertType: .logoutAlert) { [weak self] in
                   guard let self else { return }
                   self.profileLogoutService.logout()
                   guard let window = UIApplication.shared.windows.first else {
                       assertionFailure("\(#file):\(#function): Invalid window configuration")
                       return
                   }
                   window.rootViewController = SplashViewController()
               }
    }
    
    
    func setupProfilePhotoImage() {
        let imageSize = 70.0
        let profileImage = UIImage(resource: .photo)
        profilePhotoImage.image = profileImage
        profilePhotoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePhotoImage)
        profilePhotoImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        profilePhotoImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        profilePhotoImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profilePhotoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profilePhotoImage.layer.cornerRadius = imageSize / 2
        profilePhotoImage.clipsToBounds = true
    }
    
    func setupProfileFullNameLabel() {
        profileFullNameLabel.text = "Name"
        profileFullNameLabel.font = UIFont(name: "SFPro-Bold", size: 23)
        profileFullNameLabel.textColor = UIColor.ypWhite
        profileFullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileFullNameLabel)
        profileFullNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileFullNameLabel.topAnchor.constraint(equalTo: profilePhotoImage.bottomAnchor, constant: 8).isActive = true
    }
    
    func setupProfileLoginNameLabel() {
        profileLoginNameLabel.text = "@login_name"
        profileLoginNameLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        profileLoginNameLabel.textColor = UIColor.ypGray
        profileLoginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLoginNameLabel)
        profileLoginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileLoginNameLabel.topAnchor.constraint(equalTo: profileLoginNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func setupProfileBioLabel() {
        profileDescLabel.text = "Bio Info"
        profileDescLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        profileDescLabel.textColor = UIColor.ypWhite
        profileDescLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescLabel)
        profileDescLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileDescLabel.topAnchor.constraint(equalTo: profileDescLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func setupProfileExitButton() {
        exitButton.setImage(UIImage(resource: .exit), for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        view.addSubview(exitButton)
        exitButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -14).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: profilePhotoImage.centerYAnchor).isActive = true
    }
    
    
    
}

extension ProfileViewController: AlertPresenterDelegate {
    func present(_ alertToPresent: UIAlertController) {
        present(alertToPresent, animated: true)
    }
}
