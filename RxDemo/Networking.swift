//
//  Networking.swift
//  Wrapper
//
//  Created by Imac on 1/23/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol NetworkingType {
  associatedtype T: TargetType
  var provider: RxMoyaProvider<T> { get }
}

struct Networking: NetworkingType {
  typealias T = GithubAPI
  let provider: RxMoyaProvider<GithubAPI>
}

extension NetworkingType {
  
  static func defaultNetworking() -> Networking {
    return Networking(provider: newProvider(headers: [:]))
  }
  
  static func endpointsClosure<T>(headers: [String : String]) -> (T) -> Endpoint<T> where T: TargetType {
    return { target in
      var endpoint: Endpoint<T> = Endpoint<T>(url: url(route: target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding, httpHeaderFields: nil)
      
      // If we were given an headers, add it
      for key in headers.keys {
        endpoint = endpoint.adding(newHTTPHeaderFields: [key: headers[key]!])
      }
      
      return endpoint
    }
  }
}

private func newProvider<T>(headers: [String:String]) -> RxMoyaProvider<T> where T: TargetType {
  return RxMoyaProvider<T>(endpointClosure: Networking.endpointsClosure(headers: headers))
}

// MARK: - Provider support

func stubbedResponse(filename: String) -> Data! {
  @objc class TestClass: NSObject { }
  
  let bundle = Bundle(for: TestClass.self)
  let path = bundle.path(forResource: filename, ofType: "json")
  return NSData(contentsOfFile: path!) as! Data
}

extension String {
  var URLEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

func url(route: TargetType) -> String {
  return route.baseURL.appendingPathComponent(route.path).absoluteString
}
