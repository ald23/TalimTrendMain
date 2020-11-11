//
//  RecentlyWatchedView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/15/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

enum TypeOfWatch {
    case recentlyWatced
    case recomendations
}
class RecentlyWatchedViewModel : DefaultViewModelOutput {
    var error: Observable<String> = Observable("")
    
    var loading: Observable<Bool> = Observable(false)

    var videoResult : Observable<[Video]> = Observable([])
    
    func getRecentylyWatched(page: Int) -> Void {
        let parameters =  ["page": page]
        ParseManager.shared.getRequest(url: AppConstants.API.recentlyViewed, parameters: parameters, success: { ( result : PageResult <[Video]>) in
            self.videoResult.value = result.data
        }) { (error) in
            self.error.value = error
        }
    }
    func getRecomendations(page: Int) -> Void {
        let parameters =  ["page": page]
        ParseManager.shared.getRequest(url: !UserManager.isAuthorized() ? AppConstants.API.recommendedVideos : AppConstants.API.main, parameters: parameters, success: { ( result : PageResult <[Video]>) in
            if result.data.count != 0{
            self.videoResult.value.append(contentsOf: result.data)
            }
        }) { (error) in
            self.error.value = error
        }
    }
    
}




class RecentlyWatchedView: UIView {
    var didSelectVideoAction : ((Int)->())?
    var viewModel = RecentlyWatchedViewModel()
    let recentlyWatchedLabel : UILabel = {
        var label = UILabel()
        label.text = "Недавно смотрели".localized()
            label.font = .getSourceSansProSemibold(of: 15)
            label.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
            label.numberOfLines = 0
        return label
    }()
    var collectionViewDataArray = [Video]()
    var getRecomedations : ((Int)->())?
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collection.backgroundColor = UIColor.clear
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.isScrollEnabled = true
       
        return collection
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        if type == .recentlyWatced{
            viewModel.getRecentylyWatched(page: 1)
        }
        else {
            viewModel.getRecomendations(page: 1)
        }
    }
    var type : TypeOfWatch!
    
    init(type : TypeOfWatch) {
        super.init(frame: .zero)
        self.type = type
        setupViews()
        setupCollectionView()
        bind()
    }
    func bind(){
        viewModel.videoResult.observe(on: self) { (result) in
            self.collectionView.reloadData()
        }
    }
    func remakeConstraintsAfterFlip(){
        self.removeAllConstraints()
        self.layoutIfNeeded()
        self.setupViews()
        self.layoutIfNeeded()
    }
    private func setupCollectionView(){
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RecentlyWatchedCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyWatchedCollectionViewCell.cellIdentifier())
}
    
    private func setupViews(){
        addSubview(recentlyWatchedLabel)
        recentlyWatchedLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(recentlyWatchedLabel.snp.bottom).offset(10)
            make.height.equalTo(160)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecentlyWatchedView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.videoResult.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyWatchedCollectionViewCell.cellIdentifier(), for: indexPath) as! RecentlyWatchedCollectionViewCell
        
        cell.setupVideo(with: viewModel.videoResult.value[indexPath.row])
        
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 200, height: 160)
     }
    func collectionView(_ collectionView: UICollectionView, layout
                 collectionViewLayout: UICollectionViewLayout,
                                 minimumLineSpacingForSectionAt section: Int) -> CGFloat {

      return 15
     }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.type == .recomendations){
            getRecomedations?(viewModel.videoResult.value[indexPath.row].id)
        }
        else {
            NotificationCenter.default.post(name: Notification.Name(Keys.openPlayerView), object: nil)
            didSelectVideoAction?(viewModel.videoResult.value[indexPath.row].id)
        }
        
    }
    
}
