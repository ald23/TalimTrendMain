//
//  EditProfileViewMode.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/19/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

class EditProfileViewModel : DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)
    var message : Observable<String> = Observable("")
    var profileInfo : Observable<User?> = Observable(nil)
    var languageChangeMessage : Observable<String> = Observable("")
    var phone = Observable("")
    func editProfile(params: Parameters) {
        self.loading.value = true
        ParseManager.shared.multipartFormData(url: AppConstants.API.profileEdit, parameters: params, success: { (result: GeneralResultModel) in
            self.loading.value = false
            self.message.value = result.message ?? ""
        }) { (error) in
            self.loading.value = false
            self.error.value = error
        }
    }
    func getProfile(){
        ParseManager.shared.getRequest(url: AppConstants.API.profile, success: { (result : User) in
            
            self.profileInfo.value = result
            
        }) { (error) in
            self.error.value = error
        }
    }
    func languageChange(){
        ParseManager.shared.getRequest(url: "settings/changeLang", success: { (result : GeneralResultModel) in
            self.languageChangeMessage.value = result.message!
        }) { (error) in
            self.error.value = error
        }
    }
    func changePhoneNumber(phone: String){
        ParseManager.shared.postRequest(url: "profile/editPhone",parameters: ["phone": phone]) { (result : ChangePhoneModel) in
            self.phone.value = result.phone!
        } error: { (error) in
            self.error.value = error
        }
    }
}
class ChangePhoneModel: Decodable {
    var phone : String?
}
