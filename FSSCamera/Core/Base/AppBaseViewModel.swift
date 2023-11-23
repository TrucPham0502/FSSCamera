//
//  BaseViewModel.swift
//  FSSCamera
//
//  Created by Truc Pham on 14/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class AppBaseViewModel {
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    let disposeBag = DisposeBag()
    deinit {
        debugPrint("-------------------\(String(describing: type(of: self))) disposed--------------------")
    }
}

