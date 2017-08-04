//
//  ViewController.swift
//  RxDemo
//
//  Created by toan.quach on 2/17/17.
//  Copyright © 2017 toan.quach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var button: UIButton!
  let disposeBag = DisposeBag()
  
  lazy var presenter: CounterPresenter = {
    let provider = CounterProvider(buttonTap: self.button.rx.tap.asObservable())
    return CounterPresenter(provider)
  }()
  
  //let viewModel: ViewModel = ViewModel()
  
  //var count = 0 // using for traditional way
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    //  #5: Presenter
    self.presenter.count.asDriver(onErrorJustReturn: 0)
        .map { count in
            return "You have tapped that button \(count) times."
        }.drive(self.label.rx.text)
        .addDisposableTo(disposeBag)
    
    //  #4: Rx using viewmodel
//    self.button.rx.tap
//      .bindTo(viewModel.buttonTap)
//      .addDisposableTo(disposeBag)
//    
//    self.viewModel.message.asObservable()
//      .subscribe(onNext: {[unowned self] message in
//        self.label.text = message
//      }).addDisposableTo(disposeBag)
    
    
    
    //  #3: Rx using driver
//    self.button.rx.tap
//      .scan(0) { (previousValue,_) in
//        return previousValue + 1
//      }.asDriver(onErrorJustReturn: 0)
//      .map { count in
//        return "You have tapped that button \(count) times."
//      }.drive(self.label.rx.text)
//      .addDisposableTo(disposeBag)
    
    
    
    //  #2: Rx using subscribe
//    self.button.rx.tap
//        .scan(0) { (previousValue,_) in
//          return previousValue + 1
//        }.map { count in
//          return "You have tapped that button \(count) times."
//        }.subscribe(onNext: { [unowned self] message in
//          self.label.text = message
//        }).addDisposableTo(disposeBag)
    
    
    
    //  #1: traditional way
//    self.button.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
    
    // git fow using
    
    // fix bug release
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

//  func buttonTap(_ sender: AnyObject) {
//    count = count + 1
//    self.label.text = "You have tapped that button \(count) times."
//  }
}

