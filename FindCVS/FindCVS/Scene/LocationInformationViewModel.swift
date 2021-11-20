//
//  LocationInformationViewModel.swift
//  FindCVS
//
//  Created by 전지훈 on 2021/11/20.
//

import Foundation
import RxSwift
import RxCocoa

struct LocationInformationViewModel {
    
    let disposeBag = DisposeBag()
    
    //subViewModels
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()
    
    //viewModel -> view
    
    let setMapCenter: Signal<MTMapPoint>
    let errorMessage: Signal<String>
    let detailListCellData: Driver<[DetailListCellData]>
    let scrollToSelectedLocation: Signal<Int>
    
    //view -> viewModel
    
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPont = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let detailListItemSelected = PublishRelay<Int>()
    
    let documentData = PublishSubject<[Document?]>()
    
    init() {
        //지도 중심점 설정
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) {$1[$0]}
            .map{ data -> MTMapPoint in
                guard let data = data,
                      let longtitude = Double(data.x),
                      let letitude = Double(data.y) else {
                          return MTMapPoint()
                      }
                let geoCoord = MTMapPointGeo(latitude: letitude, longitude: longtitude)
                return MTMapPoint(geoCoord: geoCoord)
            }
        
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        
        let currentMapCenter = Observable
            .merge(
                selectDetailListItem,
                currentLocation.take(1),
                moveToCurrentLocation
            )
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        errorMessage = mapViewError.asObservable()
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해 주세요")
        
        detailListCellData = Driver.just([])
        scrollToSelectedLocation = selectPOIItem
            .map{$0.tag}
            .asSignal(onErrorJustReturn: 0)
    }
}
