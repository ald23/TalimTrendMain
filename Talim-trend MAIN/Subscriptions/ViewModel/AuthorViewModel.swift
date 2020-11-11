//
//  AuthorViewModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/11/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class AuthorViewModel: DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)
    
    var authorInfo: Observable<Author?> = Observable(nil)
    var authorVideoList: Observable<[Video]> = Observable([])

    
    func getAuthor(by id: Int, page: Int = 1) {
        self.loading.value = true
        let parameters: Parameters = ["id": id, "page": page]
        ParseManager.shared.getRequest(url: AppConstants.API.author, parameters: parameters, success: { (result: AuthorDetailModel<PageResult<[Video]>>) in
            self.loading.value = false
            self.authorInfo.value = result.author
            if result.videos.data.count != 0 {
                self.authorVideoList.value.append(contentsOf: result.videos.data)
            }
        }) { (error) in
            self.loading.value = false
            self.error.value = error
        }
    }
    
}
