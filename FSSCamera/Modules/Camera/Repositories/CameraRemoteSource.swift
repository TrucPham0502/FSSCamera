//
//  CameraRemoteSource.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
import RxSwift
import Cleanse
protocol CameraRemoteSource {
    func getCameraInfo(_ request: CameraInfoRequest) -> Observable<ApiResponseDto<CameraInfoResponse>>
}

class CameraRemoteSourceImpl : CameraRemoteSource {
    let api : ApiRequestManager
    let endPoint : String
    let path = "/api/v2/camera/"
    init(api: ApiRequestManager, endPoint : TaggedProvider<Tags.EndPointURL>){
        self.api = api
        self.endPoint = endPoint.get()
    }
    func getCameraInfo(_ request: CameraInfoRequest) -> Observable<ApiResponseDto<CameraInfoResponse>> {
        return api.request(.post, "\(endPoint)\(path)streaming-info-v6/", parameters: request)
    }
}
