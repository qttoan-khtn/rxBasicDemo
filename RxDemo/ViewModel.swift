//
//  ViewModel.swift
//  RxDemo
//
//  Created by toan.quach on 2/17/17.
//  Copyright © 2017 toan.quach. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {

  let buttonTap = PublishSubject<Void>()
  let message = Variable("You have tapped that button 0 time.")
  
  private let disposeBag = DisposeBag()
  
  init() {
    buttonTap.scan(0) { (previousValue, _) in
        return previousValue + 1
      }.map { count in
        return "You have tapped that button \(count) time."
      }.bindTo(message)
      .addDisposableTo(disposeBag)
  }
}
