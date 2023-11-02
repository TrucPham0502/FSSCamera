//
//  RxBinding.swift
//  FSSCamera
//
//  Created by Truc Pham on 14/08/2023.
//

import Foundation
import RxSwift
import RxCocoa



infix operator <->
infix operator >>

func >> <T>(object: T, f: (T) -> Void) -> T {
    f(object)
    return object
}

func <-> <T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { n in
            variable.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func <-> <T>(property: ControlProperty<T>, variable: BehaviorSubject<T>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { n in
            variable.onNext(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func <-> <T>(property: ControlProperty<T>, variable: WrapperSubject<T>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { n in
            variable.on(.next(n))
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func <-> <T>(subject: PublishSubject<T>, variable: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: subject)
    let bindToVariable = subject
        .subscribe(onNext: { n in
            variable.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func <-> <T >(subject: PublishSubject<T?>, variable: BehaviorRelay<T?>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: subject)
    let bindToVariable = subject
        .subscribe(onNext: { n in
            variable.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}
func <-> <T>(subject: PublishSubject<T?>, variable: PublishSubject<T?>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: subject)
    let bindToVariable = subject
        .subscribe(onNext: { n in
            variable.onNext(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}
func <-> <T >(subject: BehaviorRelay<T>, variable: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: subject)
    let bindToVariable = subject
        .subscribe(onNext: { n in
            variable.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}



extension Reactive where Base : UIViewController {
    var viewDidLoad : Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad)).map { _ in  }
    }
    var viewWillAppear : Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map { $0[0] as! Bool }
    }
    var viewDidAppear : Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidAppear(_:))).map { $0[0] as! Bool }
    }
    var viewDidDisappear : Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear(_:))).map { $0[0] as! Bool }
    }
    var viewWillDisappear : Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).map { $0[0] as! Bool }
    }
}
