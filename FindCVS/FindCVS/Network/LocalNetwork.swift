//
//  LocalNetwork.swift
//  FindCVS
//
//  Created by 전지훈 on 2021/11/22.
//

import RxSwift

class LocalNetwork {
    private let session: URLSession
    let api = LocalAPI()
    
    init(session: URLSession = .shared)
    {
        self.session = session
    }
    
    func getLocaltion(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        guard let url = api.getLocation(by: mapPoint).url else { return .just(.failure(URLError(.badURL)))}
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 2bb995dd7748df2d48ca83a01d6ef1fa", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map{ data in
                do {
                    let locationData = try JSONDecoder().decode(LocationData.self, from: data)
                    return .success(locationData)
                } catch {
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch { _ in.just(Result.failure(URLError(.cannotLoadFromNetwork)))}
            .asSingle()
    }
}
