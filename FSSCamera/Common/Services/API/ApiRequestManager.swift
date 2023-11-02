//
//  ApiRequestManager.swift
//  FSSCamera
//
//  Created by Truc Pham on 13/08/2023.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import Cleanse

protocol ApiRequestManager {
    func request<O : Codable>(
        _ method: HTTPMethod,
        _ url: String,
        parameters: Encodable?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
    ) -> Observable<ApiResponseDto<O>>
}
extension ApiRequestManager {
    func request<O : Codable>(
        _ method: HTTPMethod,
        _ url: String,
        parameters: Encodable? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> Observable<ApiResponseDto<O>> {
        return request(method, url, parameters: parameters, encoding: encoding, headers: headers)
    }
}

class ApiRequestManagerImpl : ApiRequestManager {
    let gis : String
    let package : String
    let appVersion : String
    let language: String
    init(gis : TaggedProvider<Tags.Gis>, package: TaggedProvider<Tags.Package>, appVersion: TaggedProvider<Tags.AppVersion>, appDelegate: AppDelegate) {
        self.gis = gis.get()
        self.package = package.get()
        self.appVersion = appVersion.get()
        self.language = appDelegate.getCurrentLanguage().rawValue
    }
    let manager : Session = Alamofire.Session.default
    func request<O : Codable>(
        _ method: HTTPMethod,
        _ url: String,
        parameters: Encodable? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> Observable<ApiResponseDto<O>> {
        #if DEBUG || MOCK
        debugPrint("requestData url : \(String(describing: url))")
        debugPrint("requestData headers : \(String(describing: headers))")
        #endif

//        var p : [String: Any]
//        if parameters == nil {
//            p = [
//                "Session": "270A3D4F-1CED-4E00-BEB3-2F87E07748FE",
//                "Type": nil,
//                "OperatorCode":"150"
//                ] as [String : Any]
//        }else{
//            p = parameters!
//        }
        var headers : HTTPHeaders = headers ?? [:]
        headers.add(name: "gis", value: gis)
        headers.add(name: "package", value: package)
        headers.add(name: "version", value: appVersion.replacingOccurrences(of: "-dev", with: ""))
        headers.add(name: "language", value: language)
        
        headers.add(name: "Authorization", value: "Token bad7b7030139d508c9869bb122e50750d2d879de")
//        headers.add(name: "license", value: "")
        
        return self.manager.rx
            .request(method, url, parameters: parameters?.dictionary ?? [:], encoding: encoding, headers: headers)
            .flatMap {d in
                d.rx.responseData()
            }
            .flatMap { (x) -> Observable<ApiResponseDto<O>> in
                do {
                    let (_, data) = x

                    #if DEBUG || MOCK
                    debugPrint("-------")
                    debugPrint(parameters)
                    debugPrint("-------")
                    //                    debugPrint(response)
                    debugPrint(data)
                    debugPrint(String(decoding: data, as: UTF8.self))
                    debugPrint("-------")
                    #endif

                    let decoder = JSONDecoder()
                    let parseData = try decoder.decode(ApiResponseDto<O>.self, from: data)
                    return Observable.just(parseData)
                } catch {
                    print(error)
                    return Observable.error(ParseDataError(parseClass: String(describing: O.self), errorMessage: error.localizedDescription))
                }
        }

    }

    func request(
        _ method: HTTPMethod,
        _ url: String,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> Observable<Void> {

        #if DEBUG || MOCK
        debugPrint("requestData url : \(String(describing: url))")
        debugPrint("requestData headers : \(String(describing: headers))")
        #endif

        return self.manager.rx
            .request(method, url, parameters: parameters, encoding: encoding, headers: headers)
            .flatMap { $0.rx.responseData() }
            .flatMap { (x) -> Observable<Void> in
                return Observable.just(())
        }

    }

}
