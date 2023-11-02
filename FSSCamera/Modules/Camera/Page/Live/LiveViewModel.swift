//
//  TestViewModel.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
import RxCocoa
import RxSwift
import Cleanse
class LiveViewModel : BaseViewModel<LiveViewModel.Input, LiveViewModel.Output> {
   
    let service : CameraService
    let appversion : String
    init(service : CameraService, appVersion : TaggedProvider<Tags.AppVersion>) {
        self.service = service
        self.appversion = appVersion.get()
    }
    struct Input {
        let serial : String
        let viewDidLoad : Driver<Void>
        let data: PublishSubject<CameraInfo?>
    }
    struct Output {
        let cameraInfo : Driver<CameraInfo?>
    }
    
    @PublishRelayProperty
    var cameraInfo : CameraInfo? {
        didSet {
            print(cameraInfo)
        }
    }
    
    
    
    override func transform(input: Input) -> Output {
        ($cameraInfo <-> input.data).disposed(by: disposeBag)
        input.viewDidLoad.flatMap{[unowned self] () -> Driver<CameraInfo> in
            return Observable.deferred {() -> Observable<CameraInfo> in
                return self.service.getCameraInfo(.init(serialList: [input.serial], appVersion: self.appversion, deviceName: UIDevice.modelNameIdentifier, mode: .single))
            }.trackError(errorTracker)
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }.drive($cameraInfo).disposed(by: self.disposeBag)
        
        return .init(cameraInfo: $cameraInfo.asDriverOnErrorJustComplete())
    }
    
    
}
