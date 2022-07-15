//
//  GameDetailsViewController.swift
//  CollectionViewDemo
//
//  Created by Shriram on 13/06/20.
//  Copyright © 2020 Shriram. All rights reserved.


import UIKit
import SDWebImage

class GamesViewController: UIViewController {
    var imageThumbArray = [String]()
    var imageNameArray = [String]()
    var imageRatingArray = [Double]()
    var imageurlArray = [String]()
    var imageIsPortrait = [Bool]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var collView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gamezone"
        
        
        collView?.register(UINib.init(nibName: "GameZopCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GameZopCollectionViewCell")
        self.collView?.delegate = self
        self.collView?.dataSource = self
        getURLDATA()

        if let layout = collView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
    }
    
   override func viewWillAppear(_ animated: Bool) {
        setStatusBarStyle(isBlack: false)
            appDelegate.orientationLock = .portrait
       // getGamezopData()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        getURLDATA()
//         
//    }
    
    func getURLDATA() {
        
        var request = URLRequest(url: URL(string: "https://pub.gamezop.com/v3/games?id=AMNhWd916&lang=LOCALE")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            do{
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)  as! [String:AnyObject]
                print("GAMES DATA: \(jsonData)")
                
                if let fetchAssetsDict = jsonData["games"] as? [[String : Any]] {
                    for item in fetchAssetsDict {
                        let fetchImageIsPortraitData = item["isPortrait"] as? Bool ?? false
                        let fetchAssetData = item["assets"] as? [String : Any]
                        let fetchAssetNameData = item["name"] as? [String : Any]
                        let fetchAssetURLData = item["url"] as? String ?? ""
                        let fetchThumbName = fetchAssetData?["thumb"] as? String ?? ""
                        let fetchImageName = fetchAssetNameData?["en"] as? String ?? ""
                        let fetchRatingValue = item["rating"] as? Double ?? 0
                        self.imageRatingArray.append(fetchRatingValue)
                        self.imageNameArray.append(fetchImageName)
                        self.imageThumbArray.append(fetchThumbName)
                        self.imageurlArray.append(fetchAssetURLData)
                        self.imageIsPortrait.append(fetchImageIsPortraitData)
                    }
                }
                
                DispatchQueue.main.async {
                    self.collView.reloadData()
                }
                
            }catch{
                
            }
        }
        task.resume()
    }
}

extension GamesViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageThumbArray.count > 0 {
        return imageThumbArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if imageThumbArray.count > 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameZopCollectionViewCell", for: indexPath) as! GameZopCollectionViewCell
        cell.imgGame.clipsToBounds = true
        let fetchImageUrl = imageThumbArray[indexPath.row];
            cell.imgGame?.sd_setImage(with: URL(string: fetchImageUrl), placeholderImage: nil, options: .continueInBackground, completed: nil)
        cell.lblGameName.text = imageNameArray[indexPath.row]
        cell.lblRating.text = String(format: "%.1f", imageRatingArray[indexPath.row])
        //cell.imgGame.backgroundColor = .blue
        return cell
        }
        return UICollectionViewCell()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
             return .portrait
         
     }
    
     override var shouldAutorotate: Bool {
         return true
     }
    
}

extension GamesViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfItems: CGFloat = 2
        let itemSpacing: CGFloat = 10
        
        let width = UIScreen.main.bounds.width - ((noOfItems - 1) * itemSpacing )
        let itemWidth = width / noOfItems
        let itemHeight = itemWidth + 55
        return  CGSize(width: itemWidth, height: itemHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GameDetailsViewController")  as? GameDetailsViewController
        vc?.lname = imageNameArray [indexPath.row]
        vc?.urlName = imageurlArray [indexPath.row]
        vc?.imageIsPortrait = imageIsPortrait [indexPath.row]
        vc?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}

