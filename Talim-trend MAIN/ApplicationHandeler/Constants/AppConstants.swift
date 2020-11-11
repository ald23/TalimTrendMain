//
//  AppConstants.swift
//  AlypKet
//
//  Created by Eldor Makkambayev on 3/19/20.
//  Copyright © 2020 Eldor Makkambayev. All rights reserved.
//

import Foundation
import UIKit
class AppConstants {
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
    static let navBarHeight = UINavigationController().navigationBar.bounds.height
    static let smallNavBarHeight = 40
    static let totalNaBarHeight = statusBarHeight + navBarHeight
    static func getTabbarHeight(_ tabBarController: UITabBarController?) -> CGFloat {
        guard let tabBarController = tabBarController else { return 0.0 }
        return tabBarController.tabBar.frame.size.height
    }

    class API {
        static let baseUrl = "http://91.215.136.182:1115/api/"
        
        static let login = "login"
        static let register = "register"
        
        static let allCategories = "allCategories"
        static let allAuthors = "allAuthors"
        
        static let category = "category/getById"
        static let author = "author/getById"
        
        static let subscribe = "subscribe"
        
        static let getVideo = "video/getById"
        static let profileEdit = "profile/edit"
        static let profile = "profile"
        static let recentlyViewed = "profile/recentlyViewed"
        static let favorites = "favorites"
        static let allTags = "allTags"
        
        static let searchByTags = "searchByTags"
        static let search = "search"
        static let getComments = "video/comments"
        static let addComment = "comment"
        static let recommendedVideos = "recommendedVideos"
        static let searchHistory = "searchHistory"
        static let removeSearchHistory = "removeSearchHistory"
        static let like = "like"
        static let favorite = "favorite"
        static let main = "profile/main"
        static let notofications = "settings/notificate"
    }

    
}
