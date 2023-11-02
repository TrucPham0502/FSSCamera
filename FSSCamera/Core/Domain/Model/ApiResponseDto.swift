//
//  ApiResponseDto.swift
//  FSSCamera
//
//  Created by Truc Pham on 13/08/2023.
//

import Foundation
protocol ApiResponseType {
    associatedtype Element : Codable
    var title:String? { get }
    var result:Bool { get }
    var returnCode: ReturnCode { get }
    var returnMessage: String? { get }
    var data: [Element]? { get }
    var errors:[APIFailureResponseDto?]? { get }
}
struct ApiResponseDto<Element: Codable>: ApiResponseType, Codable {
    let title:String?
    let result:Bool
    let returnCode: ReturnCode
    let returnMessage: String?
    let data: [Element]?
    let errors:[APIFailureResponseDto?]?

    enum CodingKeys: String, CodingKey {
        case returnCode = "code_status"
        case returnMessage = "message"
        case data
        case title
        case errors
        case result
    }
}

enum ReturnCode : Int
{
    case success = 1200
    case licenseExpired = 1440//giấy phép hết hạn hiện màn hình hết hạn
    case lostPermissionCompany = 1445//mất quyền truy cập công ty hiện màn hình mất quyền truy cập
    case userNotHavePermission = 1446//user này không có quyền truy cập
    case lostPermissionPlaceAndCamera = 1447//mất quyền thao tác hiện backdrop
    case cameraPreApply = 1449//hiện backdrop camera đã kích hoạt trước nên không kích hoạt được nữa
    case motionExpired = 1404 //Dữ liệu này không còn tồn tại do chính sách của gói dịch vụ.
    case unknown
}
extension ReturnCode: Codable {
    public init(from decoder: Decoder) throws {
        self = try ReturnCode(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
struct APIFailureResponseDto: Codable {
    var field:String?
    var message:String?
}
