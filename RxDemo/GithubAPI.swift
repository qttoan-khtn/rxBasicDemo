//
//  GithubAPI.swift
//  RxDemo
//
//  Created by toan.quach on 2/19/17.
//  Copyright © 2017 toan.quach. All rights reserved.
//

import Foundation
import Moya

enum GithubAPI {
  case repositories(query: String, page: Int)
}

extension GithubAPI: TargetType {


  /// The target's base `URL`.
  var baseURL: URL { return URL(string: "https://api.github.com")! }

  
  /// The path to be appended to `baseURL` to form the full `URL`.
  var path: String {
    switch self {
    case .repositories:
      return "/search/repositories"
    }
  }
  
  /// The HTTP method used in the request.
  var method: Moya.Method {
    return .get
  }
  
  /// The parameters to be incoded in the request.
  var parameters: [String: Any]? {
    switch self {
      case let .repositories(query, page):
        return [
                  "q" : query,
                  "page" : page
                ]
    }
  }
  
  /// The method used for parameter encoding.
  var parameterEncoding: ParameterEncoding { return URLEncoding.default }
  
  /// Provides stub data for use in testing.
  var sampleData: Data {
    switch self {
    case .repositories:
      return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".data(using: .utf8)!
    }
  }
  
  /// The type of HTTP task to be performed.
  var task: Task { return .request }
}
