//
//  VideoActionsView.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 7/20/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
import Photos
import Foundation

class VideoActionsView: UIView {
    var percentDownloaded : ((Double)->())?
    var downloadProgressView = UIProgressView()
    var viewModel = PlayerViewModel()
    var videoWasSavedAction = { ([Any])->() in}
    var isLiked = false {
        didSet {
            if isLiked {
                likeButton.setGradient(cornerRadius: 16)
            } else {
                likeButton.removeGradient()
            }
            likeCount += isLiked ? 1 : -1
        }
    }
    var inFavorites = false {
        didSet {
            if inFavorites {
                favouriteButton.setGradient(cornerRadius: 16)
            } else {
                favouriteButton.removeGradient()
            }
            
        }
    }
    var failedToLogIn = {()->() in }
    var downloadAction = {()->() in }
    var likeCount = 0 {
        didSet {
            likeButton.setTitle("\(likeCount)", for: .normal)
        }
    }
    var id = 0
    var urlString = ""
    var likeButton = UIButton()
    var favouriteButton = UIButton()
    var shareButton = UIButton()
   // var volumeButton = UIButton()
    var saveButton = UIButton()
    var presentActivityViewController : ((String)->())?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupActions()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func remakeConstraintsAfterFlip(){
        self.removeAllConstraints()
        self.layoutIfNeeded()
        self.addConstraints()
        self.layoutIfNeeded()
    }
    
     func setupActions() {
        likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        favouriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(downloadVideo), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(presentActivityVC), for: .touchUpInside)
    }
    @objc func likeAction() {
        guard UserManager.isAuthorized() else {
            failedToLogIn()
        return
        }
        isLiked.toggle()
        viewModel.likeVideo(id: id)
    }
    @objc func presentActivityVC(){
        presentActivityViewController?(urlString)
    }
    @objc func addToFavorites() {
        guard UserManager.isAuthorized() else {
            failedToLogIn()
            return
        }
        inFavorites.toggle()
        viewModel.addToFavorites(id: id)
        
    }
    @objc func downloadVideo(){
       
    
        download(from: URL(string: urlString)!)
 
    }
    func download(from url: URL) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)

        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }

}

extension VideoActionsView: ViewInstallation {
    func addSubviews() {
        addSubview(likeButton)
        addSubview(favouriteButton)
        addSubview(shareButton)
        addSubview(saveButton)
        saveButton.addSubview(downloadProgressView)
    }
    
    func addConstraints() {
        likeButton.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(8)
            make.height.equalTo(32)
            make.width.equalTo(55)
            make.bottom.equalTo(-10)
        }
        
        favouriteButton.snp.makeConstraints { (make) in
            make.left.equalTo(likeButton.snp.right).offset(16)
            make.top.bottom.height.equalTo(likeButton)
            make.width.equalTo((AppConstants.screenWidth - (16*6+75))/4)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.left.equalTo(favouriteButton.snp.right).offset(16)
            make.top.bottom.height.equalTo(likeButton)
            make.width.equalTo((AppConstants.screenWidth - (16*6+75))/4)
        }
        

        
        saveButton.snp.makeConstraints { (make) in
            make.left.equalTo(shareButton.snp.right).offset(16)
            make.top.bottom.height.equalTo(likeButton)
            make.right.equalTo(-40)
            make.width.equalTo((AppConstants.screenWidth - (16*6+75))/4)
        }
        downloadProgressView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func stylizeViews() {
        likeButton.layer.cornerRadius = 16
        likeButton.setTitle("\(likeCount)", for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "thumbs-up_major_monotone"), for: .normal)
        likeButton.backgroundColor = .overlayDark

        
        favouriteButton.layer.cornerRadius = 16
        favouriteButton.setImage(#imageLiteral(resourceName: "Frame 1"), for: .normal)
        favouriteButton.backgroundColor = .overlayDark

        
        shareButton.layer.cornerRadius = 16
        shareButton.setImage(#imageLiteral(resourceName: "share_minor 1"), for: .normal)
        shareButton.backgroundColor = .overlayDark
        
        downloadProgressView.progressTintColor = .mainColor
        downloadProgressView.isHidden = true
        downloadProgressView.clipsToBounds = true
        downloadProgressView.layer.cornerRadius = 16
        
        saveButton.layer.cornerRadius = 16
        saveButton.setImage(#imageLiteral(resourceName: "save_minor 1"), for: .normal)
        saveButton.backgroundColor = .overlayDark

    }
    func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            
            return data
        } catch {
            print(error)
            return nil
        }
    }
 
    func requestAuthorization(completion: @escaping ()->Void) {
            if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                PHPhotoLibrary.requestAuthorization { (status) in
                        completion()
                }
            } else if PHPhotoLibrary.authorizationStatus() == .authorized{
                completion()
            }
        }

}
extension VideoActionsView : URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            self.downloadProgressView.isHidden = true
            
        }
        let fileManager = FileManager()
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let docDirectoryURL = URL(fileURLWithPath: "\(directoryURL)")
        let destinationFileName = downloadTask.originalRequest!.url!.lastPathComponent
        let destinationURL = docDirectoryURL.appendingPathComponent(String(describing: destinationFileName))
      
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
        }
        catch {
            print(error.localizedDescription)
        }
        let objectToShare = [destinationURL]
 
//        DispatchQueue.main.async { [unowned self] in
//            self.videoWasSavedAction(objectToShare)
//        }
        requestAuthorization {
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)
                
            } completionHandler: { (success, error) in
                print(error?.localizedDescription)
            }
        }

    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.downloadProgressView.isHidden = false
        }
        let percent = Float(100*totalBytesWritten/totalBytesExpectedToWrite)
        
  
        
        DispatchQueue.main.async { [unowned self] in
            downloadProgressView.setProgress( percent/100, animated: true)
        }
    }
    
    
}

