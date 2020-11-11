//
//  SubscribeViewModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/12/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
typealias SubscribeButtonSelected = (index: Int, isSelected: Bool, isAuthor: Bool)
class SubscribeButtonViewModel: DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)
    var isSelected: Observable<SubscribeButtonSelected> = Observable((-1, false, false))

    func getSubscribe(id: Int, isAuthor: Int, index: Int = 0, completion: (() -> ())? = nil ) {
        var parameters: Parameters = ["id": id, "isAuthor": isAuthor]
        ParseManager.shared.getRequest(url: AppConstants.API.subscribe, parameters: parameters, success: { (result: ErrorResponse) in
            self.isSelected.value = SubscribeButtonSelected(index, result.message == "subscribed", isAuthor: isAuthor == 1)
            completion?()
        }) { (error) in
            self.error.value = error
        }
    }

}
