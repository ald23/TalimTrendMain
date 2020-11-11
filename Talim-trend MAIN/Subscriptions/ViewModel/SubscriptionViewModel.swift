//
//  SubscriptionViewModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/11/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

class SubscriptionViewModel: DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)
    var categoryList: Observable<[Category]> = Observable([])
    var authorList: Observable<[Author]> = Observable([])
    var categoriesPage: Int = 1
    var authorsPage: Int = 1

    func getCategories(page: Int, isFirstly: Bool = false) {
        self.categoriesPage = page
        if self.categoriesPage == 1 {
            self.categoryList.value.removeAll()
        }
        let parameters = ["page": self.categoriesPage]
        self.loading.value = isFirstly
        ParseManager.shared.getRequest(url: AppConstants.API.allCategories, parameters: parameters, success: { (result: PageResult<[Category]>) in
            self.loading.value = false
            self.categoryList.value.append(contentsOf: result.data)
        }) { (error) in
            self.loading.value = false
            self.error.value = error
        }
    }
    
    func getAuthors(page: Int, isFirst: Bool = false) {
        self.authorsPage = page
        if self.authorsPage == 1 {
            self.authorList.value.removeAll()
        }
        let parameters = ["page": self.authorsPage]
        self.loading.value = isFirst
        ParseManager.shared.getRequest(url: AppConstants.API.allAuthors, parameters: parameters, success: { (result: PageResult<[Author]>) in
            self.loading.value = false
            self.authorList.value.append(contentsOf: result.data)
        }) { (error) in
            self.loading.value = false
            self.error.value = error
        }
    }

}
