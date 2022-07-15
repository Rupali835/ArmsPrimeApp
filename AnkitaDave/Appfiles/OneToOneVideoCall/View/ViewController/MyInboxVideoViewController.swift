//
//  MyInboxVideoViewController.swift
//  Gunjan Aras App
//
//  Created by Shriram on 18/06/20.
//  Copyright © 2020 armsprime. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyJSON
import SwiftyStoreKit
import MoEngage
import NVActivityIndicatorView
import IQKeyboardManagerSwift

import CoreSpotlight
import MobileCoreServices
import SafariServices

class MyInboxVideoViewController: BaseViewController {
 
    var list = [JSON]()
    // MARK: - Properties.
  //  var loaderIndicator: NVActivityIndicatorView!
    var projects:[String] = []
    
    var selectVideoMessage = false
    var selectVideoCall = false
    
    @IBOutlet var tblMyInbox: UITableView!
    @IBOutlet var lblNoTransaction: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Requests"
        self.configureView()
        self.getVideoCallList()
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.navigationItem.hidesBackButton = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
        self.getVideoCallList() 
    }
    private func configureView(){
        tblMyInbox.register(UINib(nibName: "MyInboxVideoCell", bundle: nil), forCellReuseIdentifier: "MyInboxVideoCell")
        tblMyInbox.dataSource = self
        tblMyInbox.delegate = self
        self.tblMyInbox.rowHeight = 93
        self.tblMyInbox.estimatedRowHeight = tblMyInbox.rowHeight
        self.tblMyInbox.setNeedsUpdateConstraints()
    }
    
    //MARK:- Loader
    func setLoader() {
        loaderIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loaderIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        loaderIndicator.type = .ballClipRotateMultiple // add your type
      //  loaderIndicator.color =  hexStringToUIColor(hex: MyColors.appThemeColor)
        self.view.addSubview(loaderIndicator)
        
    }
    override func showLoader(){
        self.loaderIndicator?.startAnimating()
    }
    override func stopLoader()  {
        DispatchQueue.main.async {
            self.loaderIndicator?.stopAnimating()
        }
    }
    // MARK: - API Videocall list
    private func getVideoCallList() {
       // if Reachability.isConnectedToNetwork(){
        
            self.showLoader()
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getVideoCallList, extraHeader: nil) { [weak self] (result) in
            guard let `self` = self else {return}
            switch result {
            case .success(let data):
                print(data)
                self.list.removeAll()
                if(data["error"] as? Bool == true){
                    // self.showToast(message: "Something went wrong. Please try again!")
                    return
                }else {
                    self.list.append(contentsOf: data["data"]["list"].arrayValue)
                        // self.stopLoader()
                    if self.list.count == 0 {
                        self.lblNoTransaction.isHidden = false
                        self.lblNoTransaction.text? = "No Transaction History"
                        self.lblNoTransaction.adjustsFontSizeToFitWidth = true
                        self.lblNoTransaction.textAlignment = NSTextAlignment.center
                    }
                }
                DispatchQueue.main.async {
                    self.tblMyInbox?.reloadData()
                }
                self.stopLoader()
            case .failure(let error):
                print(error)
                self.stopLoader()
            }
        }
   }
    
   
}


extension MyInboxVideoViewController: UITableViewDataSource, UITableViewDelegate {
    
      
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  return self.list.count
        if self.list.count == 0 {
      }
        return self.list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMyInbox.dequeueReusableCell(withIdentifier: "MyInboxVideoCell", for: indexPath) as!  MyInboxVideoCell
        cell.delegate = self
        let jsonObject = self.list[indexPath.row]
        cell.loadData(jsonObject: jsonObject)
        self.stopLoader()
        let project = self.list[indexPath.row]
        cell.textLabel?.attributedText = makeAtributedString(title: (project).string ?? "", subtitle: (project).string ?? "")
          // cell.textLabel?.attributedText = makeAtributedString(title: project, subtitle: project)

           index(item: indexPath.row )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    
    func setEmptyView(title: String, message: String) {
    
    }
}

extension MyInboxVideoViewController : MyInboxVideoCellDelegate {
    func subscribeTapped(at indexPath: IndexPath, sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChild(popOverVC)
//        let jsonObject = self.list[indexPath.row]
//        print(jsonObject)
        let jsonObject = self.list[indexPath.row]
        popOverVC.Details = jsonObject
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
}

// MARK: - Custom Methods.
extension MyInboxVideoViewController {
func index(item:Int) {

   // let project = list.count
    let project = list[item]

  let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
  //attrSet.title = String (project)
    attrSet.title =  (project).string
  //attrSet.contentDescription = project[1]
   // attrSet.contentDescription = String (project)
    attrSet.contentDescription = (project).string

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
    func makeAtributedString(title:String, subtitle:String) -> NSAttributedString {

      let attrsTitle = [
        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline ),
        NSAttributedString.Key.foregroundColor: UIColor.purple
      ]

      let attrsSubtitle = [
        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline )
      ]

      let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: attrsTitle )

      let subtitleString = NSMutableAttributedString(string: subtitle, attributes: attrsSubtitle )

      titleString.append( subtitleString )

      return titleString

    }

}

