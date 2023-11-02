//
//  CameraRepository.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
import RxSwift
protocol CameraRepository {
    func getCameraInfo(_ request: CameraInfoRequest) -> Observable<CameraInfoResponse>
}

class CameraRepositoryImpl : CameraRepository {
   
    let remote: CameraRemoteSource
    init(remote: CameraRemoteSource){
        self.remote = remote
    }
    
    
    func getCameraInfo(_ request: CameraInfoRequest) -> Observable<CameraInfoResponse> {
        remote.getCameraInfo(request).valid().map{ $0.first! }
    }
    
}
