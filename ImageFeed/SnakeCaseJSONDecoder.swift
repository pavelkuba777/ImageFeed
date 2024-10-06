//
//  SnakeCaseJSONDecoder.swift
//  ImageFeed
//
//  Created by Павел Куба on 22.09.2024.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
  override init() {
    super.init()
    keyDecodingStrategy = .convertFromSnakeCase
  }
}
