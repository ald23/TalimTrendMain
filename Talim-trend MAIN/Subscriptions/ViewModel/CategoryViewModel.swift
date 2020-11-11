//
//  CategoryViewModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/11/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//


import Foundation
class CategoryViewModel: DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)
    var categoryInfo: Observable<Category?> = Observable(nil)
    var categoryVideoList: Observable<[Video]> = Observable([])

    
    func getCategory(by id: Int, page: Int = 1) {
        self.loading.value = true
        let parameters: Parameters = ["id": id, "page": page]
        ParseManager.shared.getRequest(url: AppConstants.API.category, parameters: parameters, success: { (result: CategoryDetailModel<PageResult<[Video]>>) in
            self.loading.value = false
            self.categoryInfo.value = result.category
            if result.videos.data.count != 0 {
                self.categoryVideoList.value.append(contentsOf: result.videos.data)
            }
        }) { (error) in
            self.loading.value = false
            self.error.value = error
        }
    }
    
}
