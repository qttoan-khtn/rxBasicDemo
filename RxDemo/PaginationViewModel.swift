//
//  PaginationViewModel.swift
//  RxDemo
//
//  Created by toan.quach on 2/19/17.
//  Copyright © 2017 toan.quach. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Argo
import RxOptional

class PaginationViewModel<Element: Decodable> where Element == Element.DecodedType {
  
  let networking: Networking
  
  let refreshTrigger      = PublishSubject<Void>()
  let loadNextPageTrigger = PublishSubject<Void>()
  let elements            = Variable<[Element]>([])
  let loading             = Variable<Bool>(false)
  var pageIndex:Int       = 0
  let error               = PublishSubject<Swift.Error>()
  let disposeBag          = DisposeBag()
  
  //  init data
  init(networking: Networking) {
    
    self.networking = networking
    
    let refreshRequest = self.loading.asObservable()
                              .sample(refreshTrigger)
                              .flatMap { loading -> Observable<[Element]> in
                                
                                if loading {
                                  return Observable.empty()
                                } else {
                                  self.pageIndex = 1
                                  return self.fetchElements(page: self.pageIndex)
                                }
                                
                              }
    
    let nextPageRequest = self.loading.asObservable()
                              .sample(loadNextPageTrigger)
                              .flatMap { loading -> Observable<[Element]> in
                                
                                if loading {
                                  return Observable.empty()
                                } else {
                                  self.pageIndex = self.pageIndex + 1
                                  return self.fetchElements(page: self.pageIndex)
                                }
                              }
    
    
    let request = Observable.of(refreshRequest, nextPageRequest)
                            .merge()
                            .shareReplay(1)
    
    let response = request.flatMap { repositories -> Observable<[Element]> in
                                      request
                                      .do(onError: { error in
                                        self.error.onNext(error)
                                      }).catchError({ error -> Observable<[Element]> in
                                        Observable.empty()
                                      })
                          }.shareReplay(1)
    
    
    //  combineLatest data
    Observable.combineLatest(request, response, elements.asObservable()) { request, response, elements in
      return self.pageIndex == 1 ? response : elements + response
    }.sample(response)
    .bindTo(elements)
    .addDisposableTo(disposeBag)
    
    Observable.of(
      request.map { _ in true },
      response.map { _ in false },
      error.map { _ in true }
    ).merge()
    .bindTo(loading)
    .addDisposableTo(disposeBag)
  }

  
  func fetchElements(page: Int) -> Observable<[Element]> {
    return self.networking.provider.request(.repositories(query: "swift", page: page))
               .mapArray(rootKey: "items")
  }
}
