//
//  CounterPresenter.swift
//  RxDemo
//
//  Created by toan.quach on 2/17/17.
//  Copyright © 2017 toan.quach. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CounterPresenter {
  let count: Observable<Int>
  
  init(_ provider: CounterProvider) {
    count = provider.buttonTap.scan(0) { (previousValue,_) in return previousValue + 1 }
  }
}
