//
//  HomeViewController.swift
//  Multiplex
//
//  Created by Sameer Virani on 19/05/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit
import Shimmer
import AVKit
import Alamofire
import Pulley

//import SideMenu

enum HomeCellType: String {
    case Banner = "banner"
//    case gandiBattey = "contents"
    case Video = "content"
//    case Photo = "contents"
}

enum BannerType: String {
    case Photo = "photo"
    case Video = "video"
    case Greeting = "greeting"
    case Gamezop = "gamezop"
    case DirectLine = "directline"
    case Webview = "webview"
    case Live = "live"
    case PrivateVideoCall = "private_video_call" //rupali
    case PrivateVC = "private-video-call"
}
/*
 public func delay(_ delay: Double, closure: @escaping () -> Void) {
 let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
 DispatchQueue.main.asyncAfter(
 deadline: deadline,
 execute: closure
 )
 }
 */

class HomeViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var placeHolderView: UIView!
    @IBOutlet weak var joinVCCollectionView: UICollectionView!
    @IBOutlet weak var joinVCView: UIView?
    @IBOutlet weak var cnstCollectionViewHeight: NSLayoutConstraint!

    // MARK: - Properties
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var bannerCell = BannerTableViewCell()
    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    var indexPathforPurchase = -1
    fileprivate var arrList: [List] = [] {
        didSet {
            if arrList.count > 0 {
                tblView.hideNoDataView()
            }
            tblView.reloadData()
        }
    }
    var isLogin = false
    var noOfPages: Int = 1
    var CurrentPageValue: Int = 0

    
    let modelController = RequestListModelController()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {

        super.viewDidLoad()
        
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }
        setupView()
        self.parent?.title = "Home"
        self.modelController.delegate = self
        self.modelController.joinVCCollectionView = self.joinVCCollectionView
        self.modelController.joinVCView = self.joinVCView
    }

    override func viewWillAppear(_ animated: Bool) {
        setStatusBarStyle(isBlack: false)
       // self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.isHidden = false
        
        if !self.checkIsUserLoggedIn() {
            return
        }
        self.modelController.onViewAppear()
    }
}

// MARK: - Custom Methods
extension HomeViewController {

    fileprivate func setupView() {
        setUpTableView()
        hideShowPlaceHolder(isHidden: false)
        getData()
    }
    
    private func hideShowPlaceHolder(isHidden: Bool) {
        placeHolderView.isHidden = isHidden
        for nestedView in placeHolderView.subviews {
            if !isHidden {
                let shrimmingView = FBShimmeringView(frame: nestedView.frame)
                shrimmingView.contentView = nestedView
                placeHolderView.addSubview(shrimmingView)
                shrimmingView.isShimmering = true
            } else {
                for nestedView in placeHolderView.subviews where nestedView is FBShimmeringView {
                    nestedView.removeFromSuperview()
                }
            }
            
            
            //            if let shrimingView = nestedView as? FBShimmeringView  {
            //                shrimingView.contentView = shrimingView
            //                shrimingView.isShimmering = !placeHolderView.isHidden
            //            }
        }
        
    }
    
    fileprivate func setUpTableView() {
        
        tblView.registerNib(withCell: BannerTableViewCell.self)
        tblView.registerNib(withCell: MediaTableViewCell.self)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.layoutMargins = UIEdgeInsets.zero
        tblView.separatorInset = UIEdgeInsets.zero
        tblView.refreshControl = refreshControl
        tblView.tableFooterView = UIView()
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tblView.tableHeaderView = UIView(frame: frame)
        refreshControl.addTarget(self, action: #selector(refreshHomeData(_:)), for: .valueChanged)
        refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)
    }
    
    
    
    
    @objc fileprivate func refreshHomeData(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] () in
            self.arrList = []
            if let timer  = self.bannerCell.bannerTimer {
                timer.invalidate()
                self.bannerCell.bannerTimer = nil
            }
            self.noOfPages = 1
            self.CurrentPageValue = 0
            self.getData()
        }
    }
    
    
    func contentPurchased() {
        
        tblView.reloadData()
    }
}

// MARK: - UITableView DataSource and Delegate Methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if let cellType = arrList[indexPath.row].type {
            switch cellType {
            case HomeCellType.Banner.rawValue:
                let bannerCell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier, for: indexPath) as! BannerTableViewCell
                
                bannerCell.bannerCollectionView.registerNib(withCell: BannerCollectionViewCell.self)
                bannerCell.bannerCollectionView.dataSource = self
                bannerCell.bannerCollectionView.delegate = self
                bannerCell.bannerCollectionView.tag = indexPath.row
                let cellData = arrList[indexPath.row]
                //                cellData.banners?[indexPath.item].photo {
                bannerCell.updateBannerCount(count: cellData.list?.count ?? 0)
                if let banners = arrList[indexPath.row].list {
                    bannerCell.pageControl.numberOfPages = banners.count
                }
                
                self.bannerCell = bannerCell
                
                bannerCell.bannerCollectionView.reloadData()
                
                cell = bannerCell
                
            case HomeCellType.Video.rawValue
                :
                let mediaCell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier, for: indexPath) as! MediaTableViewCell
                
                mediaCell.mediaCollectionView.registerNib(withCell: ChannelCollectionViewCell.self)
                mediaCell.mediaCollectionView.dataSource = self
                mediaCell.mediaCollectionView.delegate = self
                mediaCell.mediaCollectionView.tag = indexPath.row
                mediaCell.btnSeeAll.tag = indexPath.row
                mediaCell.btnSeeAll.addTarget(self, action: #selector(cellBtnSeeAllClicked(sender:)), for: UIControl.Event.touchUpInside)
                
                if let name = arrList[indexPath.row].name {
                    mediaCell.lblTitle.text = name
                }
                
                mediaCell.mediaCollectionView.reloadData()
                
                cell = mediaCell
            default:
                let mediaCell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier, for: indexPath) as! MediaTableViewCell
                
                mediaCell.mediaCollectionView.registerNib(withCell: ChannelCollectionViewCell.self)
                mediaCell.mediaCollectionView.dataSource = self
                mediaCell.mediaCollectionView.delegate = self
                mediaCell.mediaCollectionView.tag = indexPath.row
                mediaCell.btnSeeAll.tag = indexPath.row
                cell = mediaCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == self.arrList.count - 1) && noOfPages > CurrentPageValue {
            self.getData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 200
        if let cellType = arrList[indexPath.row].type {
            switch cellType {
            case HomeCellType.Banner.rawValue:
                height = 250
            case HomeCellType.Video.rawValue:
                let cellData = arrList[indexPath.row]
                guard let listData = cellData.list, listData.count > indexPath.row else {
                    return  200
                    
                }
                if listData.count > 0 {
                    let currentList = listData[0]
                    if let type =  currentList.type, type == "photo" {
                        height = 170
                    } else {
                        height = 200
                    }
                } else {
                    height = 200
                }
            default:
                height = 200
                break
            }
        }
        return height
    }
    
    @objc func cellBtnSeeAllClicked(sender: UIButton) {
        if let cellType = arrList[sender.tag].code {
            gotoTravelController(code: cellType)
            //            switch cellType {
            //            case HomeCellType.Video.rawValue:
            //                print("")
            //            case HomeCellType.Photo.rawValue:
            //                print("")
            //            case  HomeCellType.gandiBattey.rawValue:
            //                print("")
            //            default:
            //                print("")
            //            }
        }
        
    }
    
    private func gotoTravelController(code: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "TravelingViewController") as! TravelingViewController
        
        if let list = GlobalFunctions.returnBucketListFormBucketCode(code: code) {
            resultViewController.pageList = list
            //            resultViewController.selectedIndexVal = indexPath.row+3
            resultViewController.navigationTittle = list.name ?? ""
            resultViewController.selectedBucketCode = list.code
        }
        
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
}

// MARK: - CollectionView Delegte & DataSource Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let cellData = arrList[collectionView.tag]
        var count = 0
        
        
        
        if let cellType = cellData.type {
            switch cellType {
            case HomeCellType.Banner.rawValue:
                if let cnt = cellData.list?.count {
                    count = cnt
                }
                
           
                
            default:
                if let cnt = cellData.list?.count {
                    count = cnt
                }
                break
            }
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        let cellData = arrList[collectionView.tag]
        if let cellType = cellData.type {
         
            switch cellType {
            case HomeCellType.Banner.rawValue:
                let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as! BannerCollectionViewCell
                
                if let media = cellData.list?[indexPath.item].photo {
                    bannerCell.configurCell(media)
                }
                
                cell = bannerCell
                
            
                
            case HomeCellType.Video.rawValue:
                let mediaCell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCollectionViewCell.identifier, for: indexPath) as! ChannelCollectionViewCell
                
                guard let arrayList = cellData.list,arrayList.count > indexPath.row else {
                    return mediaCell
                }
                
                let selectedList = arrayList[indexPath.row]
                decidePurchaseContent(cell: mediaCell, list: selectedList)
                
                if selectedList.type == "photo" || selectedList.type == "poll"
                {
                    mediaCell.lblRating.text = selectedList.age_restriction_label
                    if GlobalFunctions.isContentsPaidCoins(list: selectedList)
                    {
                        if let media = selectedList.blur_photo {
                            mediaCell.configurBlurPhoto(media)
                        }
                    }
                    else
                    {
                        if let media = selectedList.photo {
                            mediaCell.configurPhoto(media)
                        }
                    }
 
                } else {
                    mediaCell.lblRating.text = selectedList.age_restriction_label
                    if let media = selectedList.video {
                        mediaCell.configurVideo(media)
                    }
                }
                
                cell = mediaCell
            default:
                let mediaCell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCollectionViewCell.identifier, for: indexPath) as! ChannelCollectionViewCell
                
                guard let arrayList = cellData.list,arrayList.count > indexPath.row else {
                    return mediaCell
                }
                cell = mediaCell
            }
        }
        
        return cell
    }
    
    
    private func decidePurchaseContent(cell: ChannelCollectionViewCell, list: List) {
        
        guard let contentType = list.type else {
            return
        }
//        if (GlobalFunctions.isContentsPaidCoins(list: list)) && contentType == "photo" {
//            cell.blurView.isHidden = false
//        } else {
//            cell.blurView.isHidden = true
//        }
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellData = arrList[collectionView.tag]
        print("size for collectionView: \(cellData)")
        
        var size: CGSize = CGSize.zero
        
        if let cellType = cellData.type {
            switch cellType {
            case HomeCellType.Banner.rawValue:
                size = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
                
           
                
                //            case HomeCellType.Photo.rawValue:
                //                size = CGSize(width: 110, height: collectionView.frame.size.height)
                //            case HomeCellType.Video.rawValue,HomeCellType.gandiBattey.rawValue:
            //                    size = CGSize(width: 220, height: collectionView.frame.size.height)
            default:
                
                let cellData = arrList[collectionView.tag]
                guard let listData = cellData.list, listData.count > indexPath.row else {
                    return  CGSize(width: 220, height: collectionView.frame.size.height)
                    
                }
                let currentList = listData[indexPath.row]
                
                if let type =  currentList.type, type == "photo"  || type == "poll"{
                    size = CGSize(width: 110, height: collectionView.frame.size.height)
                } else {
                    size = CGSize(width: 220, height: collectionView.frame.size.height)
                }
                break
            }
        }
        
        return size
    }
    
    private func playInternalVideo(item:List) {
        if let url = item.video?.url {
            playVideo(with: url)
        }
    }
    
    private func openPurchaseContentPopup(item: List, indexPath: Int) {
        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            return
        }
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
        self.addChild(popOverVC)
        popOverVC.delegate = self
        popOverVC.contentIndex = indexPath
        popOverVC.currentContent = item
        if let contentId = item._id{
            CustomMoEngage.shared.sendEventForLockedContent(id: contentId)
            if let coin = item.coins{
                popOverVC.contentId = contentId
                popOverVC.coins = Int(coin)
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        }
    }
    
    private func openSingleImageController(item: List, indexPath: Int, storeDetails: [List]) {
        let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
        let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
        SingleImageScrollViewController.storeDetailsArray = storeDetails
        SingleImageScrollViewController.pageIndex = indexPath
        SingleImageScrollViewController.selectedBucketCode = item.code
        SingleImageScrollViewController.selectedBucketName = item.name
        self.navigationController?.pushViewController(SingleImageScrollViewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = arrList[collectionView.tag]
        guard let listData = cellData.list, listData.count > indexPath.row else { return  }
        let currentList = listData[indexPath.row]
        if let cellType = cellData.type {
            switch cellType {
            case HomeCellType.Banner.rawValue:
                handleBannerNavigation(currentList, tableIndex: collectionView.tag,cellIndex: indexPath.item)
            case HomeCellType.Video.rawValue:
                
                if GlobalFunctions.isContentsPaidCoins(list: currentList) {
                    indexPathforPurchase = collectionView.tag
                    openPurchaseContentPopup(item: currentList, indexPath: indexPath.item)
                } else {
                    guard let type = currentList.type else {
                        return
                    }
                    
                    if type == "video" {
                        
                        guard let videoType = currentList.video?.player_type else  {
                            return
                        }
                        
                        if videoType == "internal" {
                            playInternalVideo(item: currentList)
                        } else {
                            playYoutubeVide(with: currentList)
                        }
                    } else {
                        openSingleImageController(item: currentList, indexPath: indexPath.item, storeDetails: listData)
                    }
                    
                }
            default:
                break
            }
        }
    }
    
    private func goToPreviewScreen(_ media: Photo) {
        
        if let cover = media.cover {
            
            self.showPhotoPreview(photo: cover)
        }
        else {
            
            //            utility.showToast(msg: stringConstants.errEmptyImage)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        
        if let _ = scrollView.superview?.superview?.superview as? BannerTableViewCell {
            self.bannerCell.pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
        }
    }
    
}

// MARK: - Navigations
extension HomeViewController {
    
    func handleBannerNavigation(_ banner: List, tableIndex:Int, cellIndex: Int) {
        
        if let type = banner.type {
            print("type: \(type)")
            switch type.lowercased() {
            case BannerType.Photo.rawValue, BannerType.Video.rawValue:
                if  let contentId = banner.value  {
                    getContentData(with: contentId, tableIndexPath: tableIndex, cellIndexPath: cellIndex)
                }
            case BannerType.Greeting.rawValue:
                
                break
            case BannerType.Gamezop.rawValue:
                self.gotoGamesController()
                
            case BannerType.DirectLine.rawValue:
                let directLinkViewController = Storyboard.main.instantiateViewController(viewController: DirectLinkViewController.self)
                directLinkViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(directLinkViewController, animated: true)
                break
                
            case BannerType.PrivateVideoCall.rawValue:  //rupali
                
                let headerPlayerController = Storyboard.wardrobe.instantiateViewController(viewController: HeaderVideoPlayerViewController.self)
                headerPlayerController.playerSate = .fromOnetoOne
                if let videoUrlPath = ArtistConfiguration.sharedInstance().privateVideoCallURL?.videoURL, let url = URL(string:videoUrlPath) {
                    headerPlayerController.viewState = BannerState.video(videoUrl: url)
                }
                let newCelebyteController = Storyboard.main.instantiateViewController(viewController: NewCelebyteVideoViewController.self)
                newCelebyteController.stateChangeClouser = { state in
                    headerPlayerController.changeSoundStatus(with: state)
                }
                
                let pulleyController = PulleyViewController(contentViewController: headerPlayerController, drawerViewController: newCelebyteController)
                pulleyController.drawerCornerRadius = 20
            
                self.navigationController?.pushViewController(pulleyController, animated: true)
                break
                
                
                case BannerType.PrivateVC.rawValue:
                    
                    let headerPlayerController = Storyboard.wardrobe.instantiateViewController(viewController: HeaderVideoPlayerViewController.self)
                    headerPlayerController.playerSate = .fromOnetoOne
                    if let videoUrlPath = ArtistConfiguration.sharedInstance().privateVideoCallURL?.videoURL, let url = URL(string:videoUrlPath) {
                        headerPlayerController.viewState = BannerState.video(videoUrl: url)
                    }
                    let newCelebyteController = Storyboard.main.instantiateViewController(viewController: NewCelebyteVideoViewController.self)
                    newCelebyteController.stateChangeClouser = { state in
                        headerPlayerController.changeSoundStatus(with: state)
                    }
                    
                    let pulleyController = PulleyViewController(contentViewController: headerPlayerController, drawerViewController: newCelebyteController)
                    pulleyController.drawerCornerRadius = 20
                
                    self.navigationController?.pushViewController(pulleyController, animated: true)
                    break
                
                
          
            case BannerType.Webview.rawValue:
                if let url = banner.value, let title =  banner.name {
                    openWbView(with: url, title: title)
                }
                break
            case BannerType.Live.rawValue:
                print("")
            //                goToLiveScreen()
            default:
                break
            }
        }
    }
    
    private func playVideo(with url: String) {
        guard let videoURL = URL(string: url) else {
            return
        }
        let player = AVPlayer(url: videoURL)
        self.playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    private func playYoutubeVide(with list: List) {
        
        guard let url = list.video?.url, let videoCode = URL(string: url)?.lastPathComponent else {
            return
        }
        
        let videoPlayerViewController =
            XCDYouTubeVideoPlayerViewController(videoIdentifier: videoCode)
        
        self.present(videoPlayerViewController, animated: true) {
            
            videoPlayerViewController.moviePlayer.play()
        }
    }
    
    @objc func didfinishplaying(note : NSNotification)
    {
        playerViewController.dismiss(animated: true,completion: nil)
    }
    
    private func openWbView(with url: String, title: String) {
        let resultViewController = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
        resultViewController.hidesBottomBarWhenPushed = true
        resultViewController.navigationTitle = title
        resultViewController.openUrl = url
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
}

// MARK: - Web Services
extension HomeViewController {
    
    func getContentData(with contentId: String, tableIndexPath: Int, cellIndexPath: Int) {
        print("\(#function) called")
        
        if Reachability.isConnectedToNetwork()
        {
            
            var strUrl = Constants.cloud_base_url + Constants.PHOTOGALARY + "\(contentId)"
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: strUrl)
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
            request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "ArtistId")
            request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                if error != nil{
                    print(error?.localizedDescription as Any)
                    
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print("Photo json \(String(describing: json))")
                    //                         self.dataDict = json
                    
                    
                    guard let dictData = json?.object(forKey: "data") as? [String:Any],let content = dictData["content"] as?  NSDictionary  else {
                        DispatchQueue.main.async {
                            self.showOnlyAlert(title: "", message: "Something went wrong")
                        }
                        return
                    }
                    
                    if let list = List(dictionary: content) {
                        DispatchQueue.main.async {
                            self.checkContentPurchased(content: list, tableIndexPath: tableIndexPath, cellIndexPath: cellIndexPath)
                        }
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                    //                       self.stopLoader()
                }
                
            }
            task.resume()
            
            
        }
    }
    
    private func checkContentPurchased(content: List, tableIndexPath: Int, cellIndexPath: Int) {
        guard self.arrList.count > tableIndexPath, let contentList = self.arrList[tableIndexPath].list else {
            return
        }
        //
        if contentList.count > cellIndexPath {
            let items = contentList[cellIndexPath]
            items._id = content._id
            if let video = content.video {
                items.video = video
            }
            self.arrList[tableIndexPath].list = contentList
        }
        
        if GlobalFunctions.isContentsPaidCoins(list: content) {
            indexPathforPurchase = tableIndexPath
            openPurchaseContentPopup(item: content, indexPath: cellIndexPath)
        } else {
            guard let type = content.type else {
                return
            }
            
            if type == "video" {
                
                guard let videoType = content.video?.player_type else  {
                    return
                }
                
                if videoType == "internal" {
                    playInternalVideo(item: content)
                } else if videoType == "youtube" {
                    playYoutubeVide(with: content)
                }
            } else {
                openSingleImageController(item: content, indexPath: cellIndexPath, storeDetails: contentList)
            }
            
        }
    }
    
    func getData() {
        
        if CurrentPageValue < noOfPages
        {
            CurrentPageValue = CurrentPageValue + 1
        } else {
            return
        }
        
        let apiName = Constants.home + "?artist_id=\(Constants.CELEB_ID)" + "&page=\(CurrentPageValue)"
        
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
                
                if  let paginationData = data["data"]["paginate_data"].dictionary {
                    if let lastPage = paginationData["last_page"]?.int {
                        self.noOfPages  = lastPage
                    }
                    
                    if let currentPage = paginationData["current_page"]?.int {
                        self.CurrentPageValue  = currentPage
                    }
                }
               // self.arrList.removeAll(keepingCapacity: false)

                
                for dict in arrList {
                    if let dicObj = dict.dictionaryObject as NSDictionary?, let list = List(dictionary: dicObj ), let listId = list._id {
                        if (!GlobalFunctions.checkContentBlockId(id: listId)) {
                            self.arrList.append(list)
                        }
                    }
                }
                
                self.getUserMetaDataNew()

                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    if self.arrList.count > 0 {
                        self.tblView.hideNoDataView()
                        self.tblView.reloadData()
                    }
                    self.hideShowPlaceHolder(isHidden: true)
                    
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
                    self.hideShowPlaceHolder(isHidden: true)
                    self.showOnlyAlert(title: "", message: error.localizedDescription)
                }
                
            }
        }
    }
    
    func getUserMetaDataNew()
    {
        let api = Constants.App_BASE_URL + Constants.META_ID + Constants.artistId_platform
        
        let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "Authorization": Constants.TOKEN,
                    "ApiKey": Constants.API_KEY,
                    "ArtistId": Constants.CELEB_ID,
                    "Platform": Constants.PLATFORM_TYPE,
                    "platform": Constants.PLATFORM_TYPE,
                    "V": Constants.VERSION,
                    ]
         
        Alamofire.request(api, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_) :
               if let json = resp.result.value as? NSDictionary
               {
                if let data = json["data"] as? NSDictionary
                {
                    if let purchaseContentData = data["purchase_content_data"] as? [[String: Any]]
                    {
                        
                        for (cIndex,lcData) in self.arrList.enumerated()
                        {
                            let lcId = lcData._id
                            
                            for lcdict in purchaseContentData
                            {
                                let id = lcdict["_id"] as? String
                                
                                if id == lcId
                                {
                                    let purchasephoto = lcdict["photo"] as? [String : Any]
                                    let lcPhoto = Photo(dict: purchasephoto)
                                   self.arrList[cIndex].photo = lcPhoto
                                    
                                  
                                }
                            }
                        }
                        self.joinVCCollectionView.reloadData()
                    }
                }
               }
                 
                break
                
            case .failure(_) :
                break
                
            }
            
        }
     
    }
    
}


extension HomeViewController: ChannelDelegate {
    func didLikeButton(_ sender: UIButton) {
        
    }
    
    func didShareButton(_ sender: UIButton) {
        
    }
    
    func didTapOpenOptions(_ sender: UIButton) {
        
    }
    
    func didTapOpenPurchase(_ sender: UIButton) {
        
        
    }
    
    func didTapWebview(_ sender: UIButton) {
        
    }
    
    func didTapButton(_ sender: UIButton) {
        //        if Reachability.isConnectedToNetwork() {
        
        if isLogin {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let CommentTableViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
            if ( self.arrList.count > 0) {
                
                let dict : List = self.arrList[sender.tag]
                let postId = dict._id
                CommentTableViewController.postId = postId ?? ""
                CommentTableViewController.screenName = "Home  Screen"
                
                self.navigationController?.pushViewController(CommentTableViewController, animated: true)
            }
        }
        else {
            //            let alert = UIAlertController(title: "Not Logged In.Please log in to continue", message: "", preferredStyle: UIAlertController.Style.alert)
            //
            //            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            //
            //            // show the alert
            //            self.present(alert, animated: true, completion: nil)
            //
            //
            //            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            //                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            //                if #available(iOS 11.0, *) {
            //                    let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            //                    self.pushAnimation()
            //                    self.navigationController?.pushViewController(resultViewController, animated: false)
            //                }
            //            })
            
            self.loginPopPop()
            return
        }
        //    else
        //    {
        //        self.showToast(message: Constants.NO_Internet_MSG)
        //
        //    }
    }
    
    //    func loginPopPop() {
    ////        liveIconClick = false
    //        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPopPopViewController") as! LoginPopPopViewController
    //        self.addChild(popOverVC)
    //        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    //        popOverVC.textLabel.text = "Hey there! log in right now to connect with me"
    //        popOverVC.coinsView.isHidden = true
    //        self.view.addSubview(popOverVC.view)
    //        popOverVC.didMove(toParent: self)
    //    }
}

extension HomeViewController: PurchaseContentProtocol {
    
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        
        guard indexPathforPurchase != -1, self.arrList.count > indexPathforPurchase, let itemList  = self.arrList[indexPathforPurchase].list, itemList.count >  index  else {
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
        
        let currentList : List = itemList[index]
        
        if let tableCell = self.tblView.cellForRow(at: IndexPath(row: indexPathforPurchase, section: 0)) as? MediaTableViewCell {
            if tableCell.mediaCollectionView.tag == indexPathforPurchase {
                tableCell.mediaCollectionView.reloadData()
            }
        }
        
        if let tableCell = self.tblView.cellForRow(at: IndexPath(row: indexPathforPurchase, section: 0)) as? BannerTableViewCell {
            if tableCell.bannerCollectionView.tag == indexPathforPurchase {
                tableCell.bannerCollectionView.reloadData()
            }
        }
        
        
        guard let type = currentList.type else {
            return
        }
        
        if type == "video" {
            
            guard let videoType = currentList.video?.player_type else  {
                return
            }
            
            if videoType == "internal" {
                playInternalVideo(item: currentList)
            } else {
                playYoutubeVide(with: currentList)
            }
        } else {
            openSingleImageController(item: currentList, indexPath: index, storeDetails: itemList)
        }
    }
    
    func loginPopPopds(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPopPopViewController") as! LoginPopPopViewController
            self.addChild(popOverVC)
            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            popOverVC.textLabel.text = "Hey there! log in right now to connect with me"
            popOverVC.coinsView.isHidden = true
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
    }
}

extension HomeViewController : RequestListModelControllerDelegate {
    func joinVideoCall(request: VideoCallRequest) {
        if !self.checkIsUserLoggedIn() {
            return
        }
        let videoCallVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallViewController.self)
        videoCallVC.request = request
        self.navigationController?.pushViewController(videoCallVC, animated: true)
    }
}

