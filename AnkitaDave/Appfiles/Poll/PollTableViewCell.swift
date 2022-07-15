//
//  PollTableViewCell.swift
//  HarbhajanSingh
//
//  Created by webwerks on 12/09/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import UIKit
import SDWebImage
import SQLite

import CoreSpotlight
import MobileCoreServices
import SafariServices

protocol PollTableViewCellDelegate {
    func didTapCommentButton(_ sender: UIButton)
    func didLikePollButton(_ sender: UIButton)
    func didSharePollButton(_ sender: UIButton)
    func didTapOpenPollOptions(_ sender : UIButton)
    func reloadCellOfTableView(index:Int)
    func showLoginAlert()
    func didTapOpenPollPurchase(_ sender : UIButton)
    func showPurchaseAlert()
}

class PollTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var pollStatTableView: UITableView!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var expireDayLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var commentTapButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var tableViewheight: NSLayoutConstraint!
    @IBOutlet weak var voteTittleLabel: UILabel!
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    var delegate: PollTableViewCellDelegate?
    @IBOutlet weak var likeTapButton: UIButton!
    let database = DatabaseManager.sharedInstance
    
    @IBOutlet weak var lockeOpenView: UIView!
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var blurrView: UIView!
    @IBOutlet weak var optionButtonTap: UIButton!
    @IBOutlet weak var shareTapButton: UIButton!
    var tapGesture : UITapGestureRecognizer!
    
    @IBOutlet weak var playButtonImgeView: UIImageView!
    @IBOutlet weak var durationView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var videoViewCountLabel: UILabel!
    @IBOutlet weak var videoViewCountView: UIView!
    let fetcher = ImageSizeFetcher()
    var projects:[[String]] = []

    //    var currentList: List?
    var currentList: List! {
        didSet {
            self.setDataOnUi()
        }
    }
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpUi()
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        projects.append( [(writePath)] )
        index(item: 0)
//        setDataOnUi()
    }
    func setUpUi() {
        mainCardView.layer.cornerRadius = 20
        mainCardView.clipsToBounds = true
//        mainCardView.borderWidth = 1
//        mainCardView.borderColor = BlackThemeColor.yellow
        self.profileImageView.layer.cornerRadius = 15
        self.profileImageView.clipsToBounds = true
        self.cellImageView.layer.cornerRadius = cellImageView.frame.size.width / 2
        self.cellImageView.layer.masksToBounds = false
        self.cellImageView.clipsToBounds = true
        self.cellImageView.layer.borderColor = UIColor.black.cgColor
        self.cellImageView.layer.borderWidth = 1
    
        self.likeButton.isHidden = false
        self.likeCountLabel.isHidden = false
        self.commentTapButton.isHidden = false
        self.commentButton.isHidden = false
        self.commentCountLabel.isHidden = false
        self.optionButton.layer.cornerRadius = 4.0
        self.playButtonImgeView.isHidden = true
        self.durationView.isHidden = true
        
//        mainCardView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
//        cardNameLabel.textColor = hexStringToUIColor(hex: MyColors.cellNameLabelTextColor)
//        dateLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
//        statusLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
//        likeCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
//        commentCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
//        voteCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
//        voteTittleLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
//        expireDayLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        
        
        cardNameLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        dateLabel.font = UIFont(name: AppFont.regular.rawValue, size: 13.0)
        likeCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        commentCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        statusLabel.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        voteCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 13.0)
        voteTittleLabel.font = UIFont(name: AppFont.light.rawValue, size: 13.0)
        expireDayLabel.font = UIFont(name: AppFont.light.rawValue, size: 13.0)
       
        pollStatTableView.register(UINib(nibName: "PollButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "PollButtonTableViewCell")
        pollStatTableView.rowHeight = 50

                let blurEffectView = VisualEffectView()
                blurEffectView.frame = blurrView.bounds
                blurEffectView.blurRadius = 12
//                blurEffectView.colorTintAlpha = 0.5
                blurEffectView.scale = 1
                blurEffectView.colorTint = .black
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.blurrView.insertSubview(blurEffectView, at: 0)
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = blurrView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.blurrView.addSubview(blurEffectView)
//        self.blurrView.bringSubviewToFront(unlockView)
        
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapBlurView(_ :)))
        self.blurrView.isUserInteractionEnabled = true
        self.blurrView.addGestureRecognizer(tapGesture)
        
        lockeOpenView.roundCorners(corners: [.bottomRight], radius: 25)
    }
    @objc func didTapBlurView (_ sender: UITapGestureRecognizer) {
        
        delegate?.didTapOpenPollPurchase(likeTapButton)
        
    }
    func setDataOnUi() {
        if let list = currentList {
            projects.append(([String(describing: list)]))
            projects.append([(Constants.celebrityName )])
            projects.append([(cardNameLabel.text ?? "")])
            index(item: 0)
            cardNameLabel.text = Constants.celebrityName
            self.cellImageView.image = UIImage(named: "celebrityProfileDP")
            profileImageView.isHidden = false
            self.videoViewCountView.isHidden = true
           
            if let thumbHeight = list.photo?.thumbHeight, let thumbWidth = list.photo?.thumbWidth {

                self.setImageHeight(currentHeight: CGFloat(thumbHeight), currentWidth: CGFloat(thumbWidth))
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                if let imageUrl = list.photo?.cover {
                    profileImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                    projects.append([(imageUrl)])
                    index(item: 0)
                }
                
            } else if let coverUrl = list.photo?.cover, let imageUrl = URL(string: coverUrl) {
                projects.append([(coverUrl)])
                index(item: 0)
                self.imageViewConstraint.constant = 400
                self.getImageHeight(imageUrl: imageUrl, list: list)
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                profileImageView.sd_imageTransition = .fade
                profileImageView.sd_setImage(with: imageUrl, completed: nil)
                
            } else if let coverUrl = list.video?.cover, let imageUrl = URL(string: coverUrl) {
                //                self.getImageSize(urlString: coverUrl, list: list)
                projects.append([(coverUrl)])
                index(item: 0)
                self.imageViewConstraint.constant = 400
                self.getImageHeight(imageUrl: imageUrl, list: list)
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                profileImageView.sd_imageTransition = .fade
                profileImageView.sd_setImage(with: imageUrl.absoluteURL, placeholderImage: nil, options: .refreshCached) { (image : UIImage?, err : Error? ,SDImageCacheTypeMemory , url : URL?) in
                    if (err == nil) {
                        self.playButtonImgeView.isHidden = false
                        self.setNeedsLayout()
                    }
                }
                
                if  list.Duration != nil && list.Duration != "" {
                    durationView.isHidden = false
                    durationLabel.isHidden = false
                    durationLabel.text = list.Duration
                    projects.append([(list.Duration ?? "")])
                    index(item: 0)
                    
                } else {
                    durationView.isHidden = true
                    durationLabel.isHidden = true
                    
                }
                
                if let view = list.stats?.views{
                    self.videoViewCountView.isHidden = false
                    self.videoViewCountLabel.text = view.roundedWithAbbreviations
                } else {
                    self.videoViewCountView.isHidden = true
                }
            } else {
                 self.imageViewConstraint.constant = 0
                self.blurrView.isHidden = true
            }
            
            
            if let isCaption = list.date_diff_for_human
            {
                self.dateLabel.isHidden = false
                self.dateLabel.text = isCaption.captalizeFirstCharacter()
                projects.append([(isCaption)])
                index(item: 0)
            }
            
            
            if list.name != "" && list.name != nil
            {
                let types: NSTextCheckingResult.CheckingType = .link
                self.statusLabel.isHidden = false
                self.statusLabel.text = list.name
                projects.append([(list.name ?? "")])
                index(item: 0)
            } else {
                //                cell.statusLabel.isHidden = false
                //                cell.statusLabel.text = currentList.name
            }
            if list.caption != "" && list.caption != nil
            {
                self.statusLabel.isHidden = false
                self.statusLabel.text = list.caption
                projects.append([String(list.caption ?? "")])
                index(item: 0)
            }
            
            if let comments = list.stats?.comments{
                self.commentCountLabel.text = comments.roundedWithAbbreviations
                projects.append([String(comments)])
                index(item: 0)
            }
            
            if let likecount = list.stats?.likes{
                self.likeCountLabel.text = likecount.roundedWithAbbreviations
                projects.append([String(likecount)])
                index(item: 0)
            }
            
            if let voteCount = list.total_votes {
                self.voteCountLabel.text = voteCount.roundedWithAbbreviations
                projects.append([String(voteCount)])
                index(item: 0)
            }
            
            if let expiryDate = list.expired_at{
                self.expireDayLabel.text = "\(expiryDate) left"
                projects.append([String(expiryDate)])
                index(item: 0)
            } else {
                self.expireDayLabel.text = "Poll Ended"
                projects.append([String(self.expireDayLabel.text ?? "")])
                index(item: 0)
            }
            
            
            if let count = list.pollStat?.count {
                self.tableViewheight.constant = CGFloat(count * 50)
                projects.append([String(count)])
                index(item: 0)
            }
            
            
            if list.commentbox_enable == "true" && list.commentbox_enable != nil && list.commentbox_enable != "" {
                self.commentTapButton.isUserInteractionEnabled = true
                self.commentTapButton.backgroundColor = UIColor.clear
                projects.append([String(list.commentbox_enable ?? "")])
               index(item: 0)
            } else {
                self.commentButton.isUserInteractionEnabled = false
                self.commentTapButton.isUserInteractionEnabled = false
                self.commentTapButton.backgroundColor =  BlackThemeColor.white
            }
          
//            if list.commercial_type == "free" {
            if currentList.coins == 0{
                self.blurrView.isHidden = true
                self.lockeOpenView.isHidden = true
                self.optionButton.isHidden = false
                self.optionButtonTap.isHidden = false
            } else {
                if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0{
                    self.blurrView.isHidden = false
                     self.lockeOpenView.isHidden = true
                    self.optionButton.isHidden = true
                    self.optionButtonTap.isHidden = true
                } else {
                     self.blurrView.isHidden = true
                     self.lockeOpenView.isHidden = false
                    self.optionButton.isHidden = false
                    self.optionButtonTap.isHidden = false
                }
            }
            
            pollStatTableView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func optionButtonAction(_ sender: Any) {
        delegate?.didTapOpenPollOptions(sender as! UIButton)
    }
    
    @IBAction func likeButtonAction(_ sender: Any) {
        delegate?.didLikePollButton(sender as! UIButton)
    }
    
    @IBAction func commentButtonAction(_ sender: Any) {
        delegate?.didTapCommentButton(sender as! UIButton)
    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        delegate?.didSharePollButton(sender as! UIButton)
    }
    
    @IBAction func unlockContentButtonAction(_ sender: Any) {
         delegate?.didTapOpenPollPurchase(likeTapButton)
    }
    
    
    func setImageHeight(currentHeight: CGFloat, currentWidth: CGFloat) {
        let ratio = 370/currentWidth
        let newheight = currentHeight * ratio
        self.imageViewConstraint.constant = newheight
        self.layoutIfNeeded()
    }
    
    var dbPath : String?
    func getImageHeight(imageUrl: URL, list: List) {
        fetcher.sizeFor(atURL: imageUrl) { (error, result) -> (Void) in
            if let height = result?.size.height, let width = result?.size.width {
                
                DispatchQueue.main.async {
                    
                    
                    var db : Connection!
                    
                    func  initDatabase( path : String) {
                        self.dbPath = path
                        do {
                            db = try Connection(path)
                            list.photo?.thumbHeight = Int(height)
                            list.photo?.thumbWidth = Int(width)
                            
                        }catch{
                            
                        }
                        
                        
                    }
                    
                    //                    self.photoImageView.frame.size = (result?.size)!
                    let ratio = 370/width
                    let newheight = height * ratio
                    self.imageViewConstraint.constant = newheight
                    self.layoutIfNeeded()
                    self.layoutIfNeeded()
                }
                
            }
        }
    }
}

extension PollTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("poll stats value \(currentList.pollStat?.count ?? 0)")
       return currentList.pollStat?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pollStatTableView.dequeueReusableCell(withIdentifier: "PollButtonTableViewCell", for: indexPath) as! PollButtonTableViewCell
        cell.selectionStyle = .none
        if let detail = currentList.pollStat?[indexPath.row]{
            cell.poll = detail
        }
        return cell
    }
}

extension PollTableViewCell: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("selected poll  => \(currentList.pollStat?[indexPath.row].label ?? "") \n content id \(currentList._id ?? "")")
        
        if !self.checkIsUserLoggedIn() {
            delegate?.showLoginAlert()
            return
        }
        
        if let isExpired = currentList.is_expired {
            if isExpired == "true"{ return }
        }
        if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0{
            delegate?.showPurchaseAlert()
            return
        }

        if GlobalFunctions.isPollAlreadySelected(list: currentList) { return }
        updateCountOfSelectedPollDetails(id: currentList.pollStat?[indexPath.row].id ?? "")
        callSubmitAPI(id: currentList.pollStat?[indexPath.row].id ?? "")
        delegate?.reloadCellOfTableView(index: likeTapButton.tag)
//         pollStatTableView.reloadData()
    }
    
    func updateCountOfSelectedPollDetails(id:String) {
        var totalVoteCount = currentList.total_votes ?? 0
        totalVoteCount = 1 + totalVoteCount
        currentList.total_votes = totalVoteCount
        
        for pollDetails in currentList.pollStat!{
            if pollDetails.id! == id {
                let currentVote = (pollDetails.votes!) + 1
                let percentage = Double(currentVote)/Double(totalVoteCount)
                pollDetails.isSelected = true
                pollDetails.votes = currentVote
//                let fraction = percentage - floor(percentage)
                let percentageDouble = 100 * percentage
                pollDetails.votes_in_percentage = percentageDouble
                database.insertIntoContentLikesTable(pollId: pollDetails.id ?? "", userID: CustomerDetails.customerData._id ?? "", contentId: currentList._id ?? "")
            } else {
                let currentVote = (pollDetails.votes!)
               let percentage = Double(currentVote)/Double(totalVoteCount)
                pollDetails.isSelected = false
                pollDetails.votes = currentVote
//                let fraction = percentage - floor(percentage)
                let percentageDouble = 100 * percentage
                pollDetails.votes_in_percentage = percentageDouble
            }
            
            
        }
        printPollDetails(arr: currentList.pollStat!)
        database.updatePollDetails(contentId: currentList._id ?? "", pollDeArr: currentList.pollStat!)
        
    }
    
    func printPollDetails(arr:[PollDetail]) {
        for p in arr {
            print("[details =>Total Votes=====> \(currentList.total_votes)] poll L (\(p.label)) v (\(p.votes)) % (\(p.votes_in_percentage)) isSlected (\(p.isSelected ? "Y" : "N"))]")
            
            projects.append([String("[details =>Total Votes=====> \(currentList.total_votes)] poll L (\(p.label)) v (\(p.votes)) % (\(p.votes_in_percentage)) isSlected (\(p.isSelected ? "Y" : "N"))]")])
            index(item: 0)
        }
    }
    
    func checkIsUserLoggedIn() -> Bool {
        if  UserDefaults.standard.object(forKey: "LoginSession") as? String == nil || UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionOut" || UserDefaults.standard.value(forKey: "LoginSession") as! String == "LoginSession"  {
            return false
        } else {
            return true
        }
    }
    
    //MARK:- Call API
    func callSubmitAPI(id:String) {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
           return
        }
        let param = ["content_id":currentList._id ?? "" ,"option_id":id ,"v":version]
//        ServerManager.sharedInstance().sendPollSubmitRequest(postData: param, apiName: "", extraHeader: nil) { (result) in
//
//            switch result {
//            case .success(let data):
//                print("API======>\(data)")
//            case .failure(let error):
//               print("API Error ======>\(error)")
//            }
//        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) {
            
            let url = NSURL(string: Constants.App_BASE_URL + Constants.pollSubmitApi)!
            let request = NSMutableURLRequest(url: url as URL)
            
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")

            request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                if error != nil{ return}
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print("Photo json \(String(describing: json))")
                } catch let error as NSError {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    func index(item:Int) {

      let project = projects[item]
      let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
      attrSet.title = project[0]
      //attrSet.contentDescription = project[1]
        attrSet.contentDescription = project[0]

      let item = CSSearchableItem(
          uniqueIdentifier: "\(item)",
          domainIdentifier: "kho.arthur",
          attributeSet: attrSet )

      CSSearchableIndex.default().indexSearchableItems( [item] )
      { error in

        if let error = error
        { print("Indexing error: \(error.localizedDescription)")
        }
        else
        { print("Search item successfully indexed.")
        }
      }

    }


    func deindex(item:Int) {

      CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"])
      { error in

        if let error = error
        { print("Deindexing error: \(error.localizedDescription)")
        }
        else
        { print("Search item successfully removed.")
        }
      }

    }
}
