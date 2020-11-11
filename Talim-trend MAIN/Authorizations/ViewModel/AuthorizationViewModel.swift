//
//  AuthorizationViewModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/7/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

protocol DefaultViewModelOutput {
    var error: Observable<String> { get }
    var loading: Observable<Bool> { get }
}

class AuthorizationViewModel: DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)
    var token: Observable<String> = Observable("")
    var localLanguage: Observable<String> = Observable("")
    var id : Observable<Int> = Observable(-1)
    var message  = Observable("")
    func getLogin(params: Parameters) {
        self.token.value = ""
        self.loading.value = true
        ParseManager.shared.postRequest(url: AppConstants.API.login, parameters: params, success: { (result: AuthorizationModel) in
            self.localLanguage.value = result.local_lang ?? ""
            self.loading.value = false
            self.token.value = result.access_token ?? ""
            
        }) { (error) in
            self.loading.value = false
            self.error.value = error
        }
    }

    func getRegistration(params: Parameters) {
        self.token.value = ""
        self.loading.value = true
        ParseManager.shared.postRequest(url: AppConstants.API.register, parameters: params, success: { (result: AuthorizationModel) in
            self.loading.value = false
       
            self.id.value = result.id!
        }) { (error) in
            self.loading.value = false
            self.error.value = error
        }
    }
 
    func getCodeConfirmation(parameters: Parameters){
        ParseManager.shared.postRequest(url: "verifyTel",parameters: parameters) { (result : AuthorizationModel) in
            self.token.value = result.access_token ?? ""
            self.localLanguage.value = "Русский"
        } error: { (error) in
            self.error.value = error
        }

    }
    func changePhone(params : Parameters){
        
        ParseManager.shared.getRequest(url: "profile/verifyNumberChange",parameters: params) { (result : VarificationModel) in
            self.message.value = result.message!
        } error: { (error) in
            self.error.value = error
        }

    }
    func varifyCode(parameters : Parameters){
        ParseManager.shared.getRequest(url: "verifyCode",parameters: parameters) { (result : VarificationModel) in
            self.message.value = result.message!
        } error: { (error) in
            self.error.value = error
        }

    }
    func forgotPassword(phone : String) {
        ParseManager.shared.getRequest(url: "forgotPassword",parameters: ["phone" : phone]) { (result : AuthorizationModel) in
            self.id.value = result.id!
        } error: { (error) in
            self.error.value = error
        }

    }
    func restorePassword(newPassword : String,phone : String) {
        var parameters = ["password": newPassword, "phone": phone]
        ParseManager.shared.postRequest(url: "restorePassword",parameters: parameters ) { (result : RestoreModel) in
            if result.access_token != nil {
                self.token.value = result.access_token!
            }
        } error: { (error) in
            self.error.value = error
        }

    }
}

class VarificationModel : Decodable
{
    var message : String?
}
