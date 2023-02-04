//
//  HomeViewModel.swift
//  VuzAssessment
//
//  Created by Krishna Venkatramani on 03/02/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum ObjectError: String, Error {
    case outOfMemory
}

class HomeViewModel: ViewModel {
    
    private let service: ImageServiceInterface
    private let selectedImage: BehaviorRelay<PixabayImage?> = .init(value: nil)
    
    init(service: ImageServiceInterface) {
        self.service = service
    }
    
    struct Input {}
    struct Output {
        let section: Driver<[TableSection]>
        let navigation: Driver<Navigation>
    }
    
    func transform(_ input: Input) -> Output {
        
        let initial = Observable<Void>.just(())
            .flatMap { [weak self] _ in
                guard let self = self else {
                    return Observable<PixabayImageResult>.error(ObjectError.outOfMemory)
                }
                
                return self.service.searchImages(query: "", limit: 20, page: 1)
            }
            .map { [weak self] (result: PixabayImageResult) -> [TableSection] in
                let rows = result.hits.map { img in
                    let model = ImageCellModel(img: img) {
                        self?.selectedImage.accept(img)
                    }
                    return TableRow<ImageCell>(model)
                }
                return [TableSection(rows: rows)]
            }
            .asDriver(onErrorJustReturn: [])
        
        let navigation: Driver<Navigation> = selectedImage
            .compactMap {
                guard let img = $0 else { return nil }
                return Navigation.toImage(image: img)
            }
            .asDriver(onErrorJustReturn: Navigation.none)
        
        return Output(section: initial, navigation: navigation)
    }
    
}

extension HomeViewModel {
    
    enum Navigation {
        case toImage(image: PixabayImage)
        case none
    }
    
}
