//
//  WardrobeViewController.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 20/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit
import AVKit
import Pulley

enum DrawerState {
    case open
    case close
}

class WardrobeViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!



    // MARK: - Properties
    fileprivate var pageNumber: Int = 0
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var totalItems: Int?
    fileprivate var imgURL: String = ""
    fileprivate var videoURL: String = ""
    fileprivate var imgHeight: Int = 0
    fileprivate var imgWidth: Int = 0
    fileprivate var isVideo: Bool = false
    fileprivate var selectedIndex: Int = 0
    fileprivate let playerController = AVPlayerViewController()
    var stateChangeClouser: ((DrawerState) -> ())?
    fileprivate var arrProductList: [ProductList] = [] {
        didSet {
            if arrProductList.count > 0 {
                collectionView.hideNoDataView()
            }
            collectionView.reloadData()
        }
    }

    fileprivate var drawerBottomSafeArea: CGFloat = 0.0 {
        didSet {
            self.loadViewIfNeeded()

            // We'll configure our UI to respect the safe area. In our small demo app, we just want to adjust the contentInset for the tableview.
            collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: drawerBottomSafeArea + 10, right: 0.0)
        }
    }

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        drawerArrow.layer.cornerRadius = 4
//        drawerArrow.clipsToBounds = true
        setupView()
//        didFetchBanner()
        didFetchProductList(resetAndFetch: true)
        self.parent?.title = "WARDROBE"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.setNavigationView(title: "WARDROBE")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Custom Methods
extension WardrobeViewController {

    fileprivate func setupView() {

        view.setGradientBackground()
        refreshControl.addTarget(self, action: #selector(refreshWardrobeData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white

        NotificationCenter.default.addObserver(self, selector: #selector(WardrobeViewController.handleOutOfStockNotification(_:)),
        name: NSNotification.Name(rawValue: "outOfStock"),
        object: nil)

        setUpCollectionView()
    }

    fileprivate func setUpCollectionView() {

        collectionView.refreshControl = refreshControl
        collectionView.registerHeader(withHeader: WardrobeBannerHeaderView.self)
        collectionView.registerNib(withCell: WardrobeCollectionViewCell.self)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }

    fileprivate func calculateImageSize() -> CGFloat {

        let myImageWidth = CGFloat(imgWidth)
        let myImageHeight = CGFloat(imgHeight)
        let myViewWidth = UIScreen.main.bounds.size.width

        let ratio = myViewWidth/myImageWidth
        let scaledHeight = myImageHeight * ratio

        return scaledHeight
    }

    fileprivate func playVideoInAVPlayerController() {

        guard let url = URL(string: videoURL) else { return }

        let avPlayer = AVPlayer(url: url)
        playerController.player = avPlayer
        playerController.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(WardrobeViewController.didFinishPlaying(info:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)

        self.present(playerController, animated: true) {
            self.playerController.player?.play()
        }
    }

    @objc fileprivate func refreshWardrobeData(_ sender: Any) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] () in
            self.didFetchProductList(resetAndFetch: true)
        }
    }

    @objc fileprivate func didTapPlayButton(_ sender: UIButton) {
        playVideoInAVPlayerController()
    }

    @objc func didFinishPlaying(info: NSNotification) {
        playerController.dismiss(animated: true, completion: nil)
    }

    @objc func handleOutOfStockNotification(_ notification: Notification) {

        DispatchQueue.main.async {
            self.arrProductList[self.selectedIndex].outofstock = "yes"
            self.collectionView.reloadItems(at: [IndexPath(item: self.selectedIndex, section: 0)])
        }
    }

    
}

// MARK: - CollectionView Delegte & DataSource Methods
extension WardrobeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrProductList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WardrobeCollectionViewCell.identifier, for: indexPath) as! WardrobeCollectionViewCell

        cell.configurCell(product: arrProductList[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let wardrobePurchaseVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobePurchaseViewController.self)
        selectedIndex = indexPath.row
        wardrobePurchaseVC.productData = arrProductList[selectedIndex]
        self.navigationController?.pushViewController(wardrobePurchaseVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {

        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WardrobeBannerHeaderView.identifierVar, for: indexPath) as! WardrobeBannerHeaderView

//            headerView.configure(urlStr: imgURL, isVideo: isVideo)
//            headerView.btnPlay.addTarget(self, action: #selector(didTapPlayButton(_:)), for: .touchUpInside)

            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if let totalElements = totalItems, totalElements > (indexPath.row + 1), indexPath.row == arrProductList.count - 1 {

            didFetchProductList()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        CGSize(width: (collectionView.frame.size.width - 30) / 2, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

//        let height = imgURL == "" ? 0.0 : calculateImageSize() + 10

        return CGSize(width: collectionView.frame.width, height: 118)
    }
}

// MARK: - Web Services
extension WardrobeViewController {

    fileprivate func didFetchProductList(resetAndFetch: Bool = false) {

        if resetAndFetch {
            pageNumber = 0
            arrProductList.removeAll()
        }

        pageNumber = pageNumber + 1
        var parameters: [String: Any] = ["page": pageNumber]
        parameters["type"] = "store"

        WebServiceHelper.shared.callGetMethod(endPoint: Constants.productsList, parameters: parameters, responseType: ProductsResponseModel.self, showLoader: false) { [weak self] (response, error) in

            self?.totalItems = response?.data?.paginate_data?.total

            if let products = response?.data?.lists, products.count > 0 {
                self?.arrProductList.append(contentsOf: products)
            } else if (self?.arrProductList.count ?? 0) <= 0 {
                var errorMessage = "No Products Found"
                if let internetError = error as? WebServiceError, internetError == .internetError {
                    errorMessage = AlertMessages.internetConnectionError
                }
                self?.collectionView.showNoDataView(title: errorMessage, color: .white)
            }

            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - AVPlayerViewControllerDelegate
extension WardrobeViewController: AVPlayerViewControllerDelegate {}


extension WardrobeViewController: PulleyDrawerViewControllerDelegate , PulleyDelegate {

    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        print("collapsedDrawerHeight = \(bottomSafeArea)")
        return (self.view.frame.height - 530) + (pulleyViewController?.currentDisplayMode == .drawer ? 20 : 0.0)
    }

    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
         print("partialRevealDrawerHeight = \(bottomSafeArea)")
        return 100 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }

    func makeUIAdjustmentsForFullscreen(progress: CGFloat, bottomSafeArea: CGFloat) {
        print("progress = \(progress)")
//        if progress > 0.9 {
//            collectionView.isScrollEnabled = true
//        } else {
//            collectionView.isScrollEnabled = false
//        }
        let OldRange  : Double = 1 - 0
        let NewRange : Double = 58 - 100
        let NewValue = (((Double(progress) - 0.0) * NewRange) / OldRange) + 0.0
        print("NewValue = \(NewValue)")
//        topOuterViewHeight.constant = CGFloat(100 - NewValue)
//        topSectionView.alpha = 1 - progress
//        gabbButton.alpha = 1 - progress
//        cancelButton.alpha = 1 - progress
//        userProfileImage.alpha = 1 - progress
//        ArrowImage.alpha = 1 - progress
//        topSectionView.alpha = 1 - progress
//        topSectionViewTopConstaint.constant = CGFloat(NewValue)
//        bottomUserNameLabel.alpha = progress
//        downArrowLeftButton.alpha = progress
//        topSectionViewHeightConstaint
//        bottomUserNameLabel : UILabel!
//        @IBOutlet var downArrowLeftButton
//        gabbButton.alpha = 1 - progress
    }

    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.open,.collapsed,.closed] // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }

    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        print("drawerChangedDistanceFromBottom = \(bottomSafeArea)")
    }



    // This function is called by Pulley anytime the size, drawer position, etc. changes. It's best to customize your VC UI based on the bottomSafeArea here (if needed). Note: You might also find the `pulleySafeAreaInsets` property on Pulley useful to get Pulley's current safe area insets in a backwards compatible (with iOS < 11) way. If you need this information for use in your layout, you can also access it directly by using `drawerDistanceFromBottom` at any time.
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        drawerBottomSafeArea = bottomSafeArea
        collectionView.isScrollEnabled = drawer.drawerPosition == .open || drawer.currentDisplayMode == .panel
        if stateChangeClouser != nil {
            let state: DrawerState = (drawer.drawerPosition == .open) ? .open : .close
            stateChangeClouser!(state)
        }
    }


    /// This function is called when the current drawer display mode changes. Make UI customizations here.
    func drawerDisplayModeDidChange(drawer: PulleyViewController) {

        print("Drawer: \(drawer.currentDisplayMode)")
        //        gripperTopConstraint.isActive = drawer.currentDisplayMode == .drawer
    }
}
