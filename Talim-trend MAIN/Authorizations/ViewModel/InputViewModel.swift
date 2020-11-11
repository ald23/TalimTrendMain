//
//  InputViewModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/7/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class InputViewModel {
    
    var showErrorBlock: (() -> ())?
    
    var errorMessage: String = "" {
        didSet {
            showErrorBlock?()
        }
    }

    var phone: String = String()
    var iin: String = String()
    private var password: String = String()

    func setValidate() -> Bool {
        guard errorMessage == "" else { return false }
        
        return true
    }
    
    func setPhone(_ phone: String) -> Bool {
        let text = phone
        let phoneNumber = String(text.suffix(text.count-2)).replacingOccurrences(of: " ", with: "")
        self.phone = "8\(phoneNumber)"
        guard self.phone != "" && self.phone.count == 11 else { errorMessage = "Неправильный формат номера"; return false }
        errorMessage = ""

        return true

    }
    
    func setPassword(_ password: String) -> Bool {
        self.password = password
        guard password != "" && self.password.count >= 8 else { errorMessage = "Пароль должен иметь не менее 8 символовa"; return true }
        errorMessage = ""

        return false

    }
    
    func setRepeatPassword(_ password: String, _ repeatPassword: String) -> Bool {
        guard password == repeatPassword else { errorMessage = "Пароли не сопадают!"; return true }
        errorMessage = ""

        return false

    }

    
    func setUserInfo(_ info: String) -> Bool {
        guard info != ""  else { errorMessage = "Все поля обязательны для заполнения"; return false }
        errorMessage = ""

        return true

    }
    
    func setIinNumber(_ iin: String) -> Bool {
        let iinNumber = String(iin.replacingOccurrences(of: "-", with: ""))
        self.iin = "\(iinNumber)"

        guard self.iin.count == 12 else { errorMessage = "Неправильный формат ИИН номера"; return true }
        errorMessage = ""
        
        return false

    }
    
    func setEmail(_ email: String) -> Bool {
        guard isValidEmail(email) else { errorMessage = "Неправильный формат e-mail адреса"; return false }
        errorMessage = ""
        
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
