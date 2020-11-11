//
//  SearchViewModel.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/24/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

class SearchViewModel : DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)
    var allTags : Observable<[Tags]> = Observable([])
    var allCategories : Observable<[Category]> = Observable([])
    var videos : Observable<[Video]> = Observable([])
    var searchHistory : Observable<[SearchHistoryModel]> = Observable([])
    var message: Observable<String> = Observable("")
    
    func getAllTags(){
        ParseManager.shared.getRequest(url: AppConstants.API.allTags,parameters: ["page": 1], success: { (result : [Tags]) in
            self.allTags.value = result
        }) { (error) in
            self.error.value = error
        }
    }
    
    func getAllCateries() {
        ParseManager.shared.getRequest(url: AppConstants.API.allCategories,parameters: ["page": 1], success: { (result: PageResult<[Category]>) in
            self.allCategories.value = result.data
        }) { (error) in
            self.error.value = error
        }
    }
    func getVideosByTags(parameters : Parameters){
        ParseManager.shared.getRequest(url: AppConstants.API.searchByTags,parameters: parameters, success: { (result : PageResult<[Video]>) in
            if result.data.count != 0{
            self.videos.value.append(contentsOf: result.data)
            }
        }) { (error) in
            self.error.value = error
        }
    }
    func getVideosSearch(parameters: Parameters){
        ParseManager.shared.getRequest(url: AppConstants.API.search,parameters: parameters, success: { (result : PageResult<[Video]>) in
            if result.data.count != 0{
                self.videos.value.append(contentsOf: result.data)
            }
        }) { (error) in
            self.error.value = error
        }
    }
    func getComments(){
        ParseManager.shared.getRequest(url: AppConstants.API.searchHistory, success: { (result : [SearchHistoryModel]) in
            self.searchHistory.value = result
        }) { (error) in
            self.error.value = error
        }
    }
    func removeComments(){
        ParseManager.shared.getRequest(url: AppConstants.API.removeSearchHistory, success: { (result : String) in
            self.message.value = result
        }) { (error) in
            self.error.value = error
        }
    }


    
    
}

class Tags : Decodable {
    var id : Int
    var name : String
}

class SearchHistoryModel : Decodable{
    var text : String
    var id :Int
}
