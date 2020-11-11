//
//  File.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/26/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class CommentViewModel: DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    
    var loading: Observable<Bool> = Observable(false)
    var successfullyAdded  = Observable(false)
    var comments: Observable<[CommentModel]> = Observable([])
    
    func getComments(parameters : Parameters) {
        ParseManager.shared.getRequest(url: AppConstants.API.getComments,parameters: parameters, success: { (result : PageResult<[CommentModel]>) in
            self.comments.value = result.data
        }) { (error) in
            self.error.value = error
        }
    }
    func leaveComment(parameters: Parameters){
        ParseManager.shared.postRequest(url: AppConstants.API.addComment,parameters: parameters, success: { (result : CommentResponse) in
            self.successfullyAdded.value = true
        }) { (error) in
            self.error.value = error
        }
    }
}

class CommentResponse : Decodable{
    var user_id: Int?
    var video_id: Int?
    var text : String?
    var id :Int?
}
