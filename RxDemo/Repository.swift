//
//  Repository.swift
//  RxDemo
//
//  Created by toan.quach on 2/19/17.
//  Copyright © 2017 toan.quach. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry

struct Repository {
  let identifier: Int
  let name: String
  let fullName: String
}

extension Repository: Decodable {
  static func decode(_ json: JSON) -> Decoded<Repository> {
    return curry(Repository.init)
      <^> json <| "id"
      <*> json <| "name"
      <*> json <| "full_name"
  }
}
