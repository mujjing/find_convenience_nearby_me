 //
//  LocationData.swift
//  FindCVS
//
//  Created by 전지훈 on 2021/11/20.
//

import Foundation

// MARK: - Welcome
struct LocationData: Codable {
    let documents: [Document]
    let meta: Meta
}

// MARK: - Document
struct Document: Codable {
    let addressName: String
    let categoryGroupCode: CategoryGroupCode
    let categoryGroupName: CategoryGroupName
    let categoryName, distance, id, phone: String
    let placeName: String
    let placeURL: String
    let roadAddressName, x, y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}

enum CategoryGroupCode: String, Codable {
    case cs2 = "CS2"
}

enum CategoryGroupName: String, Codable {
    case 편의점 = "편의점"
}

// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
    let pageableCount: Int
    var sameName: String?
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case sameName = "same_name"
        case totalCount = "total_count"
    }
}
