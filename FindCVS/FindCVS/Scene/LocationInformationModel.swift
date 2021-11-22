//
//  LocationInformationModel.swift
//  FindCVS
//
//  Created by 전지훈 on 2021/11/22.
//

import Foundation
import RxSwift

struct LocationInformationModel {
    let localNetwork:LocalNetwork
    
    init(localNetwork: LocalNetwork = LocalNetwork()) {
        self.localNetwork = localNetwork
    }
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return localNetwork.getLocaltion(by: mapPoint)
    }
    
    func documentsToCallData(_ data: [Document]) -> [DetailListCellData] {
        return data.map {
            let address = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
            let point = documentToMTMapPoint($0)
            return DetailListCellData(placeName: $0.placeName, address: address, distance: $0.distance, point: point)
        }
    }
    
    func documentToMTMapPoint(_ doc: Document) -> MTMapPoint {
        let latitude = Double(doc.x) ?? .zero
        let longitude = Double(doc.y) ?? .zero
        
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
    }
}
