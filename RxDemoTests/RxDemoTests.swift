//
//  RxDemoTests.swift
//  RxDemoTests
//
//  Created by toan.quach on 2/17/17.
//  Copyright © 2017 toan.quach. All rights reserved.
//

import XCTest
@testable import RxDemo
import RxSwift
import RxCocoa
import RxTest

class RxDemoTests: XCTestCase {
  
  let disposeBag = DisposeBag()
  var scheduler: TestScheduler!
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.scheduler = TestScheduler(initialClock: 0)

  }
  
  func testPresenterCount() {
    // Here's what the observable will signal:
    // ----[@100]---[@200]---[@300]--->
    // The unit of time isn't terribly relevant
    // as these will be run as quickly as possible.
    let buttonTaps = self.scheduler.createHotObservable([
      next(100, ()),
      next(200, ()),
      next(300, ())
      ])
    
    // An observer listens to an observable. A
    // TestableObserver (as created here) also
    // stores the signals the observable sends.
    // We will use this to compare to.
    let results = scheduler.createObserver(Int.self)
    
    // Wire up our actual code. Note we're using our
    // faked observable here as the button taps.
    let counterProvider = CounterProvider(buttonTap: buttonTaps.asObservable())
    let presenter = CounterPresenter(counterProvider)
    
    // At time zero, wire up the observer to the observable.
    self.scheduler.scheduleAt(0) {
      presenter.count.subscribe(results).addDisposableTo(self.disposeBag)
    }
    // Start the simulation
    scheduler.start()
    
    // Here's what we expect to come out. Note the same time
    // stamps, but the results are 1, 2, 3, not the () we're
    // signaling with.
    let expected = [
      next(100, 1),
      next(200, 2),
      next(300, 3)
    ]
    
    // Compare actual to expected.
    XCTAssertEqual(results.events, expected)
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
