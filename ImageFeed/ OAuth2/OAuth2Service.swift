//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Павел Куба on 30.06.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private enum OAuthConstants {
            static let unsplashOAuthTokenURLString = "https://unsplash.com/oauth/token"
        }
    
    private var completions: [(Result<String, Error>) -> Void] = []
    private init(){}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code
        else {
            print("\(#file):\(#function):\(NetworkError.duplicateRequest.description) with code: \(code)")
            completion(.failure(NetworkError.duplicateRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code)
        else {
            print("\(#file):\(#function):\(NetworkError.invalidRequest.description) with code: \(code)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, NetworkError>) in
            DispatchQueue.main.async {
                guard let self else { return }
                self.task = nil
                self.lastCode = nil
                switch result {
                case .failure(let error):
                    print("\(#file):\(#function): failure \(error.description))")
                    completion(.failure(error))
                case .success(let decodedData):
                    completion(.success(decodedData.accessToken))
                }
            }
        }
        task.resume()
    }
    
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: OAuthConstants.unsplashOAuthTokenURLString) else {
            print("\(#file):\(#function): Unable to create URLComponents with wtring \(OAuthConstants.unsplashOAuthTokenURLString)")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let url = urlComponents.url else {
            print("\(#file):\(#function): Unable to create URLComponents")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}

