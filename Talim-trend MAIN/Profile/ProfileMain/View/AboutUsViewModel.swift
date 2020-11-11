//
//  AboutUsViewModel.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 9/17/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

class AboutUsViewModel : DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    
    var loading: Observable<Bool> = Observable(false)
    var policy : Observable<String> = Observable("")
    var terms : Observable<String> = Observable("")
    var about : Observable<String> = Observable("")
    var partners = Observable("")
    
    func getAboutUs(){
        ParseManager.shared.getRequest(url: "about", success: { (result : AboutUsModel) in
            if !UserManager.isAuthorized()
            {
                if UserManager.getCurrentLang() == "Русский"{
                    self.policy.value = result.privacy_policy_rus!
                    self.terms.value = result.term_rus!
                    self.about.value = result.about_rus!
            }
                else {
                    self.policy.value = result.privacy_policy_kaz!
                    self.terms.value = result.term_kaz!
                    self.about.value = result.about_kaz!}
            }
            else {
                self.policy.value = result.privacy!
                self.terms.value = result.term!
                self.about.value = result.about!
            }
        }) { (error) in
            self.error.value = error
        }
    }
    func getPartners(){
        ParseManager.shared.getRequest(url: "partners") { (result : AboutUsModel) in
            self.partners.value = result.body!
        } error: { (error) in
            self.error.value = error
        }

    }
}
