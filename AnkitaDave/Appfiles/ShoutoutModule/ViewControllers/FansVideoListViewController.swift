//
//  FansVideoListViewController.swift
//  AnveshiJain
//
//  Created by Bhavesh Chaudhari on 05/07/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import AVKit

class FansVideoListViewController: UIViewController {

    @IBOutlet var fansVideoCollectionView: UICollectionView!

    var greetingList = [Greetings]()
    private var pageNumber: Int = 0
    private var totalItems: Int?
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = stringConstants.appName
        refreshControl.addTarget(self, action: #selector(refreshWardrobeData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        fansVideoCollectionView.refreshControl = refreshControl
        fansVideoCollectionView.registerNib(withCell: VideoGreetingCollectionViewCell.self)
        fansVideoCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0.0, bottom: 15, right: 0.0)
        fansVideoCollectionView.dataSource = self
        fansVideoCollectionView.delegate = self
        getData(resetAndFetch: true)
    }
}

extension FansVideoListViewController {

    private func playVideoOnPlayer(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

    @objc private func refreshWardrobeData(_ sender: Any) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] () in
            self.getData(resetAndFetch: true)
        }
    }

}

extension FansVideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return greetingList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mediaCell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoGreetingCollectionViewCell.identifier, for: indexPath) as! VideoGreetingCollectionViewCell
        if let video = greetingList[indexPath.item].video {
            mediaCell.configurVideo(video)
        }
        return mediaCell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

       return  CGSize(width: (collectionView.frame.size.width - 30) / 2, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let videoPath = greetingList[indexPath.item].video?.url, let vieoUrl = URL(string:videoPath) {
            playVideoOnPlayer(url: vieoUrl)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if let totalElements = totalItems, totalElements > (indexPath.row + 1), indexPath.row == greetingList.count - 1 {

            getData()
        }
    }

}

extension FansVideoListViewController {
           func getData(resetAndFetch: Bool = false) {

            if resetAndFetch {
                pageNumber = 0
                greetingList.removeAll()
            }

            pageNumber = pageNumber + 1
            let apiName = "\(Constants.FANS_VIDEO)?platform=\(Constants.PLATFORM_TYPE)&v=\(ShoutoutConfig.version)&page=\(pageNumber)"

                guard Reachability.isConnectedToNetwork() else {
                    self.showOnlyAlert(title: "", message: Constants.NO_Internet_MSG)
                    return
                }

            ServerManager.sharedInstance().getRequest(postData: nil, apiName: apiName, extraHeader: nil) { (result) in
             switch result {
             case .success(let data):

                 guard let error = data["error"].bool, error == false else {
                     if let arrErrors = data["error_messages"].arrayObject as? [String] {
                         self.showOnlyAlert(title: "", message: arrErrors[0])
                     }
                     return
                 }

                 guard let arrList = data["data"]["list"].array else {

                     self.showOnlyAlert(title: "", message: "somthing went wrong")

                     return
                 }

                 self.totalItems = data["data"]["paginate"]["total"].int

                 for dict in arrList {
                    let list : Greetings = Greetings(dictionary: dict.dictionaryObject! as [String:Any])
                     self.greetingList.append(list)
                 }

                 DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.fansVideoCollectionView.reloadData()
                 }



    //             if let arrData = HomePageDetails.object(arrList) {
    //                DispatchQueue.main.async {
    //                    self.hideShowPlaceHolder(isHidden: true)
    //                    self.arrList.removeAll()
    ////                    self.arrList.append(contentsOf: arrData)
    //                    self.tblView.reloadData()
    //                }
    //
    //            }

             case .failure(let error):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
//                    self.hideShowPlaceHolder(isHidden: true)
                    self.showOnlyAlert(title: "", message: error.localizedDescription)
                }

             }
            }
        }
}
