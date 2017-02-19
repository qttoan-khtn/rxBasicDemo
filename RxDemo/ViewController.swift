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
  
  var viewModel: PaginationViewModel<Repository>!
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let networking = Networking.defaultNetworking()
    self.viewModel = PaginationViewModel<Repository>(networking: networking)
    
    viewModel.elements.asObservable()
      .subscribe(onNext: { element in
        print(element)
      })
      .addDisposableTo(disposeBag)
    
    self.tableView.rx.contentOffset
      .flatMap { _ in
        self.tableView.contentOffset.y + self.tableView.frame.size.height + 20 > self.tableView.contentSize.height
          ? Observable.just(())
          : Observable.empty()
    }.bindTo(viewModel.loadNextPageTrigger)
    .addDisposableTo(disposeBag)

    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

