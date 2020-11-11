//
//  FavoritesViewModel.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

class FavoritesViewModel : DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)
    var videos : Observable<[Video]> = Observable([])
    var update = Observable(false)
    func getLikedVideos(parameters: Parameters){
        ParseManager.shared.getRequest(url: AppConstants.API.favorites,parameters: parameters, success: { [weak self] (result: PageResult<[Video]>) in
            self?.update.value = true
            if result.data.count != 0{
                self?.videos.value.append(contentsOf: result.data)
            }
            self?.update.value = false
            
        }) { [weak self] (error) in
            self?.error.value = error
        }
    }
    
    
}
