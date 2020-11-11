//
//  File.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/19/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

class ProfileViewModel : DefaultViewModelOutput {
    
    var error  = Observable("")
    var loading = Observable(false)
    var profileInfo : Observable<User?> = Observable(nil)
    var message  = Observable("")
    
    func getProfile(){
        ParseManager.shared.getRequest(url: AppConstants.API.profile, success: { (result : User) in
            
            self.profileInfo.value = result
            
        }) { (error) in
            self.error.value = error
        }
    }
    func notificationToggle(){
        ParseManager.shared.getRequest(url: AppConstants.API.profile, success: { (result : GeneralResultModel) in
            if result.message != nil{
            self.message.value = result.message!
            }
        }) { (error) in
            self.error.value = error
        }
    }

}
