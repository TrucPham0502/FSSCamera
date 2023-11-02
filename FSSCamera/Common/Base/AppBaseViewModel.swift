//
//  AppBaseViewModel.swift
//  FSSCamera
//
//  Created by Truc Pham on 14/08/2023.
//

import Foundation
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    var activityIndicator : ActivityIndicator { get }
    var errorTracker: ErrorTracker { get }
    func transform(input: Input) -> Output
}


class BaseViewModel<I, O> : AppBaseViewModel, ViewModelType {
    func transform(input: I) -> O {
        var o: O!
        return o
    }
    
    deinit {
        debugPrint("-------------------\(String(describing: type(of: self))) disposed--------------------")
    }
    
}
