//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Павел Куба on 30.06.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    let error = NetworkError.httpStatusCode(statusCode)
                    fulfillCompletionOnTheMainThread(.failure(error))
                    print("httpStatusCode error:", error)
                }
            } else if let error = error {
                let networkError = NetworkError.urlRequestError(error)
                fulfillCompletionOnTheMainThread(.failure(networkError))
                print("urlRequest error:", networkError)
            } else {
                let networkError = NetworkError.urlSessionError
                fulfillCompletionOnTheMainThread(.failure(networkError))
                print("urlSession error:", networkError)
            }
        })
        
        return task
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
