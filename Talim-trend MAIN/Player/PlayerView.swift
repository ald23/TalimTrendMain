//
//  PlayerViewController.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 7/20/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//



import UIKit

import Foundation

protocol PlayerVCDelegate {
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndSwipe(toState: stateOfVC)
}

class PlayerView: UIView {
    
    var id = 1 {
        didSet {
            self.getVideo(by: id)
            actionsView.id = id
            viewModel.getComments(parameters: ["id": id,"limit":2,"page":1])
        }
    }
    
    var authorsID = 0
    var openCommentPageClosure = {(id: Int) -> () in}
    var openAuthorPage = {(id: Int) -> () in}
    
    var state = stateOfVC.hidden
    var direction = Direction.none
    var isDescriptionOpened = false
    var delegate: PlayerVCDelegate?
    
    var viewModel = PlayerViewModel()
    var subscribeViewModel = SubscribeButtonViewModel()
    var failedToLogIn = {()->() in }
    private var viewForGesture = UIView()
    private var closeButton = UIButton()
    
    private var tableView = UITableView()
    
    private var hidenLabelView = HidenLabelView()
    var playerView = VideoPlayerView()
    
    var actionsView = VideoActionsView()
    var chanelView = VideoChanelView()
    var commentsView = CommentView()
    
    private var nextVideoView = NextVideoView()
    private var lastVideoView = NextVideoView()
    
    private var recomendedVideoListView = RecentlyWatchedView(type: .recomendations)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        bind(to: viewModel, subscribeViewModel)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func remakeConstraintsAfterFlip(){

        removeAllConstraints()
        playerView.remakeConstraintsAfterFlip()
        actionsView.remakeConstraintsAfterFlip()
        chanelView.remakeConstraintsAfterFlip()
        commentsView.remakeConstraintsAfterFlip()
        nextVideoView.remakeConstraintsAfterFlip()
        lastVideoView.remakeConstraintsAfterFlip()
        recomendedVideoListView.remakeConstraintsAfterFlip()
        
        self.layoutIfNeeded()
        self.addConstraints()
        
        self.layoutIfNeeded()
    }

    private func bind(to viewModel: PlayerViewModel, _ subscribeViewModel: SubscribeButtonViewModel) {
        viewModel.error.observe(on: self) {
            if $0 != "" {
                
            }
        }
        viewModel.loading.observe(on: self) { loading in
            if (loading) {
                LoaderView.show()
            } else {

                LoaderView.hide()
            }
        }
        viewModel.video.observe(on: self) { [weak self] video in
            guard let video = video, let `self` = self else { return }
            self.setupData(data: video)
            self.tableView.reloadData()
            
        }
        viewModel.comments.observe(on: self) {[weak self] comments in
            guard  let `self` = self else { return }
            self.tableView.reloadData()
        }
    }
    
    private func setupData(data: VideoDetailModel) {
        if let video = data.video.path{
            playerView.startPlay(by: video.serverUrlString)
            
        }
        authorsID = data.author.id
        chanelView.currentVideoID = data.author.id
        actionsView.id = data.video.id
        
        if let video = data.video.path{
            self.actionsView.urlString = video.serverUrlString
        }
        if let status = data.author.is_subscribed{
            self.chanelView.isSubscribed = status
        }
        actionsView.likeCount = data.video.number_of_likes ?? 0
        actionsView.inFavorites  = data.video.is_favorite!
        chanelView.setupData(data: data.author)
        hidenLabelView.setupData(data: data)
    }

//    MARK: - Parse functions
    
    private func getVideo(by id: Int) {
        self.viewModel.getVideo(by: id)
        
        
        
    }

//    MARK: - Simple functions
    
    private func maximizeView(scaleFactor: CGFloat = 0) {
        playerView.playerView.settingsButton.isHidden = false
        tableView.isHidden = false
        closeButton.isHidden = true
        playerView.isUserInteractionEnabled = true
        
        print("111 translation: ".uppercased(), "\(scaleFactor)")
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.playerView.snp.remakeConstraints { (make) in
                    make.top.left.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy((scaleFactor < 0.9 ? 1 : 10*(scaleFactor - 0.9)))
                    make.height.equalTo(250)
                }
                self.hidenLabelView.snp.remakeConstraints { (make) in
                    make.bottom.top.equalToSuperview()
                    make.left.right.equalTo(self.snp.left)
                }
                
                self.hidenLabelView.alpha = 0
                self.tableView.alpha = 1
                
                self.playerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                self.playerView.layer.cornerRadius = 20
                self.layer.cornerRadius = 0
                
                self.layoutIfNeeded()
            }
        }

        
        hidenLabelView.isHidden = true
        
    }
    
    private func minimizeView(_ completion: (() -> ())? = nil) {
        playerView.playerView.settingsButton.isHidden = true
        hidenLabelView.isHidden = false
        playerView.isUserInteractionEnabled = false
        playerView.showHideControlViews()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.playerView.snp.remakeConstraints { (make) in
                make.top.left.equalToSuperview()
                make.width.equalTo(100)
                make.bottom.equalToSuperview()
            }
            
            self.hidenLabelView.snp.remakeConstraints { (make) in
                make.bottom.top.equalToSuperview()
                make.left.equalTo(self.playerView.snp.right).offset(6)
                make.right.equalTo(-32)
            }
            self.hidenLabelView.alpha = 1
            self.tableView.alpha = 0
            
            self.playerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.playerView.layer.cornerRadius = 10
            self.layer.cornerRadius = 10

            self.layoutIfNeeded()
        }, completion: { (Bool) in
            completion?()
            self.closeButton.isHidden = false
        })
        
        tableView.isHidden = true
    }
    
    func animate()  {
        switch self.state {
        case .fullScreen:
        
            self.maximizeView()
            
        case .minimized:
            
            self.minimizeView()
        default: break
        }
    }

    
    func changeValues(scaleFactor: CGFloat, toState: stateOfVC) {
        if scaleFactor < 1 {
            self.layer.cornerRadius = 10*scaleFactor
            self.layer.masksToBounds = true

            switch toState {
            case .fullScreen:
                viewForGesture.snp.remakeConstraints { (make) in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(250)
                }
                maximizeView(scaleFactor: scaleFactor)
            case .minimized:
                viewForGesture.snp.remakeConstraints { (make) in
                    make.edges.equalToSuperview()
                }

            default:
                break
            }
        }
    }

    @objc func closeAction() {
        playerView.player.cleanPlayer()
        NotificationCenter.default.post(name: NSNotification.Name(Keys.closePlayerView), object: nil)
    }
    
    @objc func toCommentsObjcFunc(){
        guard UserManager.isAuthorized() else {
            self.failedToLogIn()
            return
        }
        minimizeView()
        self.openCommentPageClosure(id)
    }
    
    
    @objc func showPlayerView() {
        maximizeView()
        self.state = .fullScreen
    }
    
    @objc func showToMaximize(_ gesture: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(Keys.openPlayerView), object: nil)
    }
    
    @objc func gestureToPlayerView(_ gesture: UITapGestureRecognizer) {
    }

    @objc func minimizeGesture(_ sender: UIPanGestureRecognizer) {
        var finalState = stateOfVC.fullScreen
        let velocity = sender.velocity(in: nil)
        if abs(velocity.x) < abs(velocity.y) {
            switch self.state {
            case .fullScreen:
                let factor = (abs(sender.translation(in: nil).y) / AppConstants.screenHeight)
                self.changeValues(scaleFactor: factor, toState: .minimized)
                self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
                
                finalState = factor < 0.5 ? .fullScreen : .minimized
            case .minimized:
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / AppConstants.screenHeight)
                self.changeValues(scaleFactor: factor, toState: .fullScreen)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
                finalState = factor < 0.5 ? .fullScreen : .minimized
                
            default: break
            }
            if sender.state == .ended {
                self.state = finalState
                self.animate()
                self.delegate?.didEndSwipe(toState: self.state)
            }
        }
    }
}

extension PlayerView {
    private func setupViews() {
        addSubviews()
        addConstraints()
        stylizeViews()
        setupAction()
    }
    
    private func addSubviews() {
        addSubview(hidenLabelView)
        addSubview(playerView)
        addSubview(closeButton)
        addSubview(tableView)
    //    addSubview(viewForGesture)
    }
    //MARK: - CONSTRAINTS
    private func addConstraints() {
        hidenLabelView.snp.makeConstraints { (make) in
            make.bottom.top.equalToSuperview()
            make.left.right.equalTo(self.snp.left)
        }
        playerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
//        viewForGesture.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(250)
//        }
        closeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.top.equalTo(20)
            make.height.width.equalTo(20)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(playerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    private func setUptableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .base
        
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.cellIdentifier())
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.cellIdentifier())
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionTableViewCell.cellIdentifier())
        tableView.register(VideoDescriptionTableViewCell.self, forCellReuseIdentifier: VideoDescriptionTableViewCell.cellIdentifier())
        
    }
    private func setupPlayer(){
        
        playerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        playerView.layer.cornerRadius = 20
        playerView.delegate = self
        playerView.player.cleanPlayer()
    }
    //MARK: - stylizeViews
    private func stylizeViews() {
        backgroundColor = .base
     

        
        recomendedVideoListView.recentlyWatchedLabel.text = "     Рекомендации".localized()
        
        setUptableView()
        setupPlayer()
 
        
        hidenLabelView.isHidden = true
        hidenLabelView.alpha = 0
        
        nextVideoView.titleLabel.text = "Следующее".localized()
        lastVideoView.titleLabel.text = "Предыдущее".localized()
        
        closeButton.isHidden = true
        closeButton.setImage(#imageLiteral(resourceName: "x"), for: .normal)
    }
    
    private func setupAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showPlayerView), name: NSNotification.Name(Keys.openPlayerView), object: nil)
        
        let tapToSeeComments = UITapGestureRecognizer(target: self, action: #selector(toCommentsObjcFunc))
            commentsView.addGestureRecognizer(tapToSeeComments)
        
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)

        let tapToHidedLabelView = UITapGestureRecognizer(target: self, action: #selector(showToMaximize(_:)))
        self.hidenLabelView.addGestureRecognizer(tapToHidedLabelView)
        
        let tapToPlayerView = UITapGestureRecognizer(target: self, action: #selector(gestureToPlayerView(_:)))
        self.playerView.addGestureRecognizer(tapToPlayerView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(minimizeGesture(_:)))
        self.viewForGesture.addGestureRecognizer(panGesture)
        recomendedVideoListView.getRecomedations = { id in
            self.id = id
            
        }
        let channelGesture = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        chanelView.addGestureRecognizer(channelGesture)
    }
    @objc func openProfile(){
        self.minimizeView()
        openAuthorPage(authorsID)
    }
}

extension PlayerView: PopNavigateDelegate {
    func popNavigate(animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(Keys.hidePlayerView), object: nil)
        minimizeView()
        self.state = .minimized
    }
}
//MARK: -  UITableViewDelegate, UITableViewDataSource
extension PlayerView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        [isDescriptionOpened ? 2 : 1, 0, 0, viewModel.comments.value.count, 0, viewModel.video.value?.nextVideo == nil ? 0 : 1, 0, viewModel.video.value?.prevVideo == nil ? 0 : 1, 0][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: VideoDescriptionTableViewCell.cellIdentifier(),for: indexPath) as! VideoDescriptionTableViewCell
                    cell.moreButton.isHidden = isDescriptionOpened
                
                    cell.moreAction = {
                        self.isDescriptionOpened = true
                        tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .automatic)
                    }
                
                if let data = viewModel.video.value {
                    cell.setupData(data: data.video)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.cellIdentifier(),for: indexPath) as! DescriptionTableViewCell
                if let data = viewModel.video.value {
                    cell.setupData(data: data.video)
                }

                return cell
            }
        } else if indexPath.section == 5 || indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.cellIdentifier(),for: indexPath) as! VideoTableViewCell
            cell.shareButton.isHidden = true
                if indexPath.section == 5 &&  viewModel.video.value?.nextVideo != nil{
                    cell.setupData(data: viewModel.video.value!.nextVideo!)
                }
                else if indexPath.section == 7 && viewModel.video.value?.prevVideo != nil {
                    cell.setupData(data: viewModel.video.value!.prevVideo!)
                }
            return cell
        }
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.cellIdentifier(), for: indexPath) as! CommentTableViewCell
            cell.selectionStyle = .none
            cell.setupData(comment: viewModel.comments.value[indexPath.row])
        
            return cell
        }
     
        else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 5 &&  viewModel.video.value?.nextVideo != nil{
            self.id = viewModel.video.value!.nextVideo!.id
        }
        else if indexPath.section == 7 && viewModel.video.value?.prevVideo != nil {
            self.id = viewModel.video.value!.prevVideo!.id
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [0,
                UITableView.automaticDimension, UITableView.automaticDimension,
                0, UITableView.automaticDimension,
                0, UITableView.automaticDimension,
                0,UITableView.automaticDimension][section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return [nil,
                actionsView, chanelView,
                nil, nextVideoView,
                nil, lastVideoView,
                nil, recomendedVideoListView][section]
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         return [nil,
                 nil, nil,
                 commentsView, nil,
                 nil, nil,
                 nil, nil][section]
     }
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         return [0,
                0, 0,
                UITableView.automaticDimension, 0,
                0, 0,
                0,0][section]
     }
}
