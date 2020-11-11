//
//  PlayerViewModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/18/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class PlayerViewModel: DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    var message: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)
    var video: Observable<VideoDetailModel?> = Observable(nil)
    let manager = ParseManager.shared
    var comments : Observable<[CommentModel]> = Observable([])
    
    func getVideo(by id: Int) {
        let params = ["id": id]
        self.loading.value = true
        manager.getRequest(url: AppConstants.API.getVideo, parameters: params, success: { (result: VideoDetailModel) in
            self.loading.value = false
            self.video.value = result
        }) { (error) in
            self.loading.value = false
            self.error.value = error
        }
    }
    func getComments(parameters : Parameters) {
        ParseManager.shared.getRequest(url: AppConstants.API.getComments,parameters: parameters, success: { (result : PageResult<[CommentModel]>) in
            self.comments.value = result.data
        }) { (error) in
            self.error.value = error
        }
    }
    
    func likeVideo(id : Int){
        let params = ["id": id]
        manager.getRequest(url: AppConstants.API.like, parameters: params , success: { (result : GeneralResultModel) in
            self.message.value = result.message!
        }) { (error) in
            self.error.value = error
        }
    }
    func addToFavorites(id : Int){
        let params = ["id": id]
        manager.getRequest(url: AppConstants.API.favorite, parameters: params , success: { (result : GeneralResultModel) in
            self.message.value = result.message!
        }) { (error) in
            self.error.value = error
        }
    }
}
