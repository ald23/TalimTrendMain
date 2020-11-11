//
//  SearchByView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/23/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit


class SearchByView: UIView {
    //MARK: - proporties
    var searchByLabel : UILabel = {
        var label = UILabel()
        label.text = "Искать по".localized()
            label.textColor = .boldTextColor
            label.font = .getSourceSansProSemibold(of: 15)
        
        return label
    }()
    var searchBySwitcherValue = "name"
    var searchBySwitcherValueAction = {(name : String)->() in }
    var hasFirstOpenedThePage = true
    var searchViewModel = SearchViewModel()
    var selectedSubCategoryId: Int?
    var allParametersAction : ((String,Int?)->())? // what was selected on switcher and what was selected on subSection
    
    var switcher = SwitcherView(firstTitle: "По названию".localized(), secondTitle: "По автору".localized(), thirdTitle: "По хэштегам".localized())
    var searchInInputView = InputView(inputType: .plainText, placeholder: "Искать в".localized(), icon: #imageLiteral(resourceName: "chevron-right_minor 1"))
    
    var categoriesPicker = UIPickerView()
    //MARK: - init
    override func layoutSubviews() {
        searchViewModel.getAllCateries()
        switch searchBySwitcherValue {
        case "name":
            switcher.firstButtonSelected()
        case "author":
            switcher.secondButtonSelected()
        case "category":
            switcher.thirdButtonSelected()
        default:
            break
        }
        
    }
    func setupSwitcherView(){
//        switch searchBySwitcherValue {
//        case "name":
//            switcher.firstButtonSelected()
//        case "author":
//            switcher.secondButtonSelected()
//        case "category":
//            switcher.thirdButtonSelected()
//        default:
//            break
//        }
    }
    func setupSwitcherAction(){
        switcher.firstAction = { [unowned self] in
            self.searchBySwitcherValue = "name"
            self.searchBySwitcherValueAction("name")
            self.allParametersAction?(self.searchBySwitcherValue,self.selectedSubCategoryId)
        }
        switcher.secondAction = {
            self.searchBySwitcherValue = "author"
            self.searchBySwitcherValueAction("author")
            self.allParametersAction?(self.searchBySwitcherValue,self.selectedSubCategoryId)
        }
        switcher.thirdAction = {
            self.searchBySwitcherValue = "category"
            self.searchBySwitcherValueAction("category")
             self.allParametersAction?(self.searchBySwitcherValue,self.selectedSubCategoryId)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSwitcherAction()
        setupViews()
        setupPicker()
        setupViewModel()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViewModel(){
        searchViewModel.allCategories.observe(on: self) { (result) in
            self.categoriesPicker.reloadAllComponents()
        }
    }
    func setupPicker(){
        categoriesPicker.delegate = self
        categoriesPicker.dataSource = self
        searchInInputView.textField.inputView = categoriesPicker
    }
    //MARK: - setup
    func setupViews(){
        addSubview(searchByLabel)
        searchByLabel.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(20)
           
        }
        addSubview(switcher)
        switcher.snp.makeConstraints { (make) in
            make.top.equalTo(searchByLabel.snp.bottom).offset(12)
            make.left.equalTo(searchByLabel)
            make.right.equalTo(-20)
            make.height.equalTo(36)
        }
        addSubview(searchInInputView)
        searchInInputView.snp.makeConstraints { (make) in
            make.top.equalTo(switcher.snp.bottom).offset(20)
            make.left.right.equalTo(switcher)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
        }
    }
    
}
extension SearchByView : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         searchViewModel.allCategories.value.count + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            return " "
        }
    
        return searchViewModel.allCategories.value[row - 1].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row != 0{
            selectedSubCategoryId =  searchViewModel.allCategories.value[row - 1].id
            searchInInputView.textField.text =  searchViewModel.allCategories.value[row - 1].name
        }
        else {
            selectedSubCategoryId = nil
        }
         self.allParametersAction?(self.searchBySwitcherValue,self.selectedSubCategoryId)
    }
    
    
}
