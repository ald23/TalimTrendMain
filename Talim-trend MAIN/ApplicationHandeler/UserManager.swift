//
//  UserManager.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/7/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class UserManager {

    //    MARK: - Properties
    static let userDefaults = UserDefaults.standard

    //    MARK: - Keys
//    private let deviceTokenIdentifier = "deviceTokenIdentifier"
//    private let userIdentifier = "userIdentifier"


    //    MARK: - Creation of user session


    
    
    static func getCurrentUser() -> User? {
        let jsonDecoder = JSONDecoder()
        if let userData = userDefaults.value(forKey: Keys.currentUser) as? Data {
            do {
                let currentUser = try jsonDecoder.decode(User.self, from: userData)
                return currentUser
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    static func setVideoId(video id: Int) {
        userDefaults.set(id, forKey: Keys.videoID)
    }
    static func getVideoId() -> Int?{
        return userDefaults.integer(forKey: Keys.videoID)
    }
    
    static func setCurrentToken(to token: String) {
        userDefaults.set(token, forKey: Keys.currentToken)
    }
    static func setCurrentLang(lang: String) {
        userDefaults.set(lang, forKey: Keys.lang)
    }
    static func getCurrentLang() -> String? {
         return userDefaults.string(forKey: Keys.lang)
     }
    static func getCurrentToken() -> String? {
        return userDefaults.string(forKey: Keys.currentToken)
    }
    static func isAuthorized() -> Bool{
        return UserManager.getCurrentToken() != nil
    }
    static func deleteCurrentSession() {
        userDefaults.set(nil, forKey: Keys.currentToken)
        userDefaults.set(nil, forKey: Keys.currentUser)
        AppCenter.shared.makeRootController()
    }
    static func setFirebaseToken(token : String){
        userDefaults.set(token, forKey: Keys.fbtoken)
    }
    static func getFirebaseToken() -> String? {
        return userDefaults.string(forKey: Keys.fbtoken)
    }
    
}
