# rxBasicDemo
using Observable, Driver, ViewModel, Presenter

#1: Observable
    self.button.rx.tap
        .scan(0) { (previousValue,_) in
          return previousValue + 1
        }.map { count in
          return "You have tapped that button \(count) times."
        }.subscribe(onNext: { [unowned self] message in
          self.label.text = message
        }).addDisposableTo(disposeBag)


#2: Driver
    self.button.rx.tap
      .scan(0) { (previousValue,_) in
        return previousValue + 1
      }.asDriver(onErrorJustReturn: 0)
      .map { count in
        return "You have tapped that button \(count) times."
      }.drive(self.label.rx.text)
      .addDisposableTo(disposeBag)



#3: ViewModel
    self.button.rx.tap
      .bindTo(viewModel.buttonTap)
      .addDisposableTo(disposeBag)
    
    self.viewModel.message.asObservable()
      .subscribe(onNext: {[unowned self] message in
        self.label.text = message
      }).addDisposableTo(disposeBag)


#4: Presenter
    self.presenter.count.asDriver(onErrorJustReturn: 0)
        .map { count in
            return "You have tapped that button \(count) times."
        }.drive(self.label.rx.text)
        .addDisposableTo(disposeBag)
