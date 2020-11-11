//
//  SearchTableViewCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/22/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    private lazy var layout = UICollectionViewFlowLayout()
    private  lazy var collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
    var sectionCell = 0 
    var viewModel = SearchViewModel()
    var selectedTags = [Int]()
    var lastSelectedCategory: Int?
    var tagSelectionAction : (([Int])->())?
    var categorySelectionAction : ((Int?)->())?
    var lastSelectedItem : Int?
    
    private func viewModelMethods(){
        viewModel.getAllTags()
        viewModel.getAllCateries()
    }

    private func bind(){
        viewModel.allCategories.observe(on: self) { (categories) in
            self.collectionView.reloadData()
        }
        viewModel.allTags.observe(on: self) { (tags) in
            self.collectionView.reloadData()
        }
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
        isMultipleTouchEnabled = true
    
        setupCollectionView()
        viewModelMethods()
        bind()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews(){
       addSubview(collectionView)
          collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(17)
            make.right.equalTo(-90)
            make.bottom.equalTo(-16)
          }
    }
  
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
       
        collectionView.backgroundColor = .clear
        
        collectionView.register(TagsCollectionViewCell.self, forCellWithReuseIdentifier:
            TagsCollectionViewCell.cellIdentifier())
    }
    
}
extension SearchTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sectionCell == 0 {
            return viewModel.allTags.value.count
        }
        else {
            return  viewModel.allCategories.value.count
        }
    
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCollectionViewCell.cellIdentifier(), for: indexPath) as! TagsCollectionViewCell
       
        if sectionCell == 0 {
            if viewModel.allTags.value.count != 0 {
                cell.tagLabel.text =  viewModel.allTags.value[indexPath.item].name
            }
        }
        else {
            if viewModel.allCategories.value.count != 0 {
                cell.tagLabel.text =  viewModel.allCategories.value[indexPath.item].name
            }
                //you can only select 1 category
                cell.isselected =  indexPath.item == lastSelectedItem
   
        }
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
                let cell = collectionView.cellForItem(at: indexPath) as! TagsCollectionViewCell
                if sectionCell == 0{
                    if cell.isselected {
                        selectedTags = selectedTags.filter { $0 != viewModel.allTags.value[indexPath.item].id}
                    }
                    else {
                        selectedTags.append(viewModel.allTags.value[indexPath.item].id)
                    }
                        tagSelectionAction?(selectedTags)
                        cell.isselected.toggle()
                }
                else {
                    if lastSelectedCategory != viewModel.allCategories.value[indexPath.item].id{
                        lastSelectedCategory = viewModel.allCategories.value[indexPath.item].id
                        lastSelectedItem = indexPath.item
                    }
                    else {
                        lastSelectedCategory = nil
                        lastSelectedItem = nil
                    }
                    collectionView.reloadData()
                    categorySelectionAction?(lastSelectedCategory)
        
                }
                
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var text = String()
        if sectionCell == 0{
             text = String(describing: viewModel.allTags.value[indexPath.item].name)
        }
        else {
            text = String(describing: viewModel.allCategories.value[indexPath.item].name)
        }
        let cellWidth = text.size(withAttributes:[.font: UIFont.getSourceSansProSemibold(of: 13)]).width + 15
        
        return CGSize(width: cellWidth, height: 30.0)
        
     }
    func collectionView(_ collectionView: UICollectionView, layout
                collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 10
     }
}

