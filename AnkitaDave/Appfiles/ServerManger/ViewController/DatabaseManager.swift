//
//  DatabaseManager.swift
//  Poonam Pandey
//
//  Created by Razrcorp  on 15/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import SQLite

class DatabaseManager: NSObject {
    
    static let sharedInstance = DatabaseManager()
    var dbPath : String?
    
    ////gifts
    let Gifts = Table("Gifts")
    let Stat = Table("Stats")
    let Bucket = Table("Buckets")
    let CustomerProfile = Table("CustomerProfile")
    let Badges = Table("Badges")
    let ContentLikes = Table("ContentLikes")
    let ContentPurchase = Table("ContentPurchase")
    let SocialJunction = Table("SocialJunction")
    let Videos = Table("Videos")
    let HideContent = Table("HideContent")
    let CommentTable = Table("Comment")
    let ReplyTable = Table("Reply")
    let PurchaseTable = Table("Purchase")
    let SpendingTable = Table("Spending")
    let RewardsTable = Table("Rewards")
    let FavFans = Table("FavFans")
    let SpendingGift = Table("SpendingGift")
    let PassbookTable = Table("Passbook")
    let Poll = Table("Poll")
    let selectedPoll = Table("SelectedPoll")
    let ContentPurchaseLive = Table("ContentPurchaseLive")
    
    
    ///
    var db : Connection!
    
    func initDatabase( path : String) {
        dbPath = path
        do {
            db = try Connection(path)
            
            do {

                try db.run(CustomerProfile.addColumn(Expression<String?>("directline_room_id")))

            } catch  {
                print(error.localizedDescription)
            }
            
            
        }catch{
            
        }
        
        
    }
    
    //    if db.userVersion == 0 {
    //    // handle first migration
    //    db.userVersion = 1
    //    }
    //    if db.userVersion == 1 {
    //    // handle second migration
    //    db.userVersion = 2
    //    }
    func updateCustomerCoins(coinsValue : Int) {
        let coins = Expression<Int?>("coins")
        do {
            let update = CustomerProfile.update( coins <- coinsValue)
            try db.run(update)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func updateCustomerProfileImage(imageValue: String) {
        let image = Expression<String?>("picture")
        do {
            let update = CustomerProfile.update(image <- imageValue)
            try db.run(update)
        }catch(let error ) {
            print(error.localizedDescription)
        }
    }
    
    func updateMobileNumber(mobileNumber: String) {
        let mobile = Expression<String?>("mobile")
        do {
            let update = CustomerProfile.update(mobile <- mobileNumber)
            try db.run(update)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func updateEmailNumber(emailId: String) {
              let email = Expression<String?>("email")
              do {
                  let update = CustomerProfile.update(email <- emailId)
                  try db.run(update)
              } catch (let error) {
                  print(error.localizedDescription)
              }
          }
    
    func createPurchaseTable() {
        
        let updated_at = Expression<String>("updated_at")
        let created_at = Expression<String>("created_at")
        let package_price = Expression<Int>("package_price")
        let package_coins = Expression<Int>("package_coins")
        let vendor = Expression<String>("vendor")
        let coins_after_purchase = Expression<Int>("coins_after_txn")
        let currency_code = Expression<String>("currency_code")
        let package_sku = Expression<String>("package_sku")
        let customer_id = Expression<String>("customer_id")
        let order_status = Expression<String>("order_status")
        let artist_id = Expression<String>("artist_id")
        let _id = Expression<String>("_id")
        let package_xp = Expression<Int>("package_xp")
        let transaction_price = Expression<Double>("transaction_price")
        
        do{
            try db.run(PurchaseTable.create(ifNotExists: true) { t in
                t.column(_id, primaryKey: true)
                t.column(updated_at)
                t.column(created_at)
                t.column(package_coins)
                t.column(package_price)
                t.column(vendor)
                t.column(coins_after_purchase)
                t.column(currency_code)
                t.column(package_sku)
                t.column(customer_id)
                t.column(order_status)
                t.column(artist_id)
                t.column(package_xp)
                t.column(transaction_price)
                
            })
            
        }catch{
            
            
        }
        
    }
    func insertIntoPurchaseTable(purchaseData: Purchase) {
        
        let updated_at = Expression<String>("updated_at")
        let created_at = Expression<String>("created_at")
        let package_price = Expression<Int>("package_price")
        let package_coins = Expression<Int>("package_coins")
        let vendor = Expression<String>("vendor")
        let coins_after_purchase = Expression<Int>("coins_after_txn")
        let currency_code = Expression<String>("currency_code")
        let package_sku = Expression<String>("package_sku")
        let customer_id = Expression<String>("customer_id")
        let order_status = Expression<String>("order_status")
        let artist_id = Expression<String>("artist_id")
        let _id = Expression<String>("_id")
        let package_xp = Expression<Int>("package_xp")
        let transaction_price = Expression<Double>("transaction_price")
        
        do{
            let insert = PurchaseTable.insert( _id <- purchaseData._id ?? "" , created_at <- purchaseData.created_at ?? "" ,   updated_at <- purchaseData.updated_at ?? "" ,  package_sku <- purchaseData.package_sku ?? "" ,  package_coins <- purchaseData.package_coins ?? 0 ,  package_price <- purchaseData.package_price ?? 0,  vendor <- purchaseData.vendor ?? "",  customer_id <- purchaseData.customer_id ?? "" ,  order_status <- purchaseData.order_status ?? "" , artist_id <- purchaseData.artist_id ?? "" ,  transaction_price <- purchaseData.transaction_price ?? 0.0,  package_xp <- purchaseData.package_xp  ?? 0, currency_code <- purchaseData.currency_code ?? "", coins_after_purchase <- purchaseData.coins_after_purchase ?? 0)
            try db.run(insert)
            
        }catch{
            
        }
        
    }
    func getFormPurchaseTable() -> [Purchase] {
        
        //        let dictionary = Dictionary
        var purchaseArray = [Purchase]()
        
        let updated_at = Expression<String>("updated_at")
        let created_at = Expression<String>("created_at")
        let package_price = Expression<Int>("package_price")
        let package_coins = Expression<Int>("package_coins")
        let vendor = Expression<String>("vendor")
        let coins_after_purchase = Expression<Int>("coins_after_txn")
        let currency_code = Expression<String>("currency_code")
        let package_sku = Expression<String>("package_sku")
        let customer_id = Expression<String>("customer_id")
        let order_status = Expression<String>("order_status")
        //        let artist_id = Expression<String>("artist_id")
        let _id = Expression<String>("_id")
        let package_xp = Expression<Int>("package_xp")
        let transaction_price = Expression<Double>("transaction_price")
        
        do{
            
            if self.tableExists(tableName: "Purchase") {
                
                for purchaseData in try db.prepare(PurchaseTable) {
                    let returnPurchase : Purchase = Purchase(dict: NSDictionary.init() as! [String : Any])
                    
                    returnPurchase._id = purchaseData[_id]
                    returnPurchase.updated_at = purchaseData[updated_at]
                    returnPurchase.created_at = purchaseData[created_at]
                    returnPurchase.package_xp = purchaseData[package_xp]
                    returnPurchase.package_price = purchaseData[package_price]
                    returnPurchase.package_coins = purchaseData[package_coins]
                    returnPurchase.vendor = purchaseData[vendor]
                    returnPurchase.coins_after_purchase = purchaseData[coins_after_purchase]
                    returnPurchase.currency_code = purchaseData[currency_code]
                    returnPurchase.package_sku = purchaseData[package_sku]
                    returnPurchase.customer_id = purchaseData[customer_id]
                    returnPurchase.order_status = purchaseData[order_status]
                    returnPurchase.transaction_price = purchaseData[transaction_price]
                    purchaseArray.append(returnPurchase)
                }
            }
        }catch{
        }
        return purchaseArray
    }
    
    
    
    
    func createPassbookTable() {
        let _id = Expression<String>("_id")
        let coins_after_txn = Expression<Int>("coins_after_txn")
        let coins_before_txn = Expression<Int>("coins_before_txn")
        let total_coins = Expression<Int>("total_coins")
        let xp = Expression<Int>("xp")
        let amount = Expression<Int>("amount")
        let coins = Expression<Int>("coins")
        let status = Expression<String>("status")
        let platform_version = Expression<String>("platform_version")
        let txn_type = Expression<String>("txn_type")
        let updated_at = Expression<String>("updated_at")
        let created_at = Expression<String>("created_at")
        let quantity = Expression<Int>("quantity")
        let package_price = Expression<Int>("package_price")
        let platform = Expression<String>("platform")
        let entity_id = Expression<String>("entity_id")
        let entity = Expression<String>("entity")
        let passbook_applied = Expression<Bool>("passbook_applied")
        
        // LEDGER META INFO
        let thumb = Expression<String>("thumb")
        let caption = Expression<String>("caption")
        let type = Expression<String>("type")
        let video = Expression<String>("video")
        let name = Expression<String>("name")
        let audio = Expression<String>("audio")
        let description = Expression<String>("description")
        let vendor_txn_id = Expression<String>("vendor_txn_id")
        let currency_code = Expression<String>("currency_code")
        let transaction_price = Expression<Double>("transaction_price")
        let vendor = Expression<String>("vendor")
        
        // ARTIST
        let first_name = Expression<String>("first_name")
        let last_name = Expression<String>("last_name")
        
        do{
            try db.run(PassbookTable.create(ifNotExists: true) { t in
                print("Passbook PassbookTable.create")
                t.column(_id, primaryKey: true)
                t.column(coins_after_txn)
                t.column(coins_before_txn)
                t.column(total_coins)
                t.column(xp)
                t.column(amount)
                t.column(coins)
                t.column(status)
                t.column(platform_version)
                t.column(txn_type)
                t.column(updated_at)
                t.column(created_at)
                t.column(quantity)
                t.column(package_price)
                t.column(platform)
                t.column(entity_id)
                t.column(entity)
                t.column(passbook_applied)
                
                // LEDGER META INFO
                t.column(thumb)
                t.column(caption)
                t.column(type)
                t.column(video)
                t.column(name)
                t.column(audio)
                t.column(description)
                t.column(vendor_txn_id)
                t.column(currency_code)
                t.column(transaction_price)
                t.column(vendor)
                
                t.column(first_name)
                t.column(last_name)
            })
        }catch{
            
        }
    }
    
    func insertIntoPassbook(transaction : LedgerTransaction)
    {
        print("Passbook insertIntoPassbook")
        let _id = Expression<String>("_id")
        let coins_after_txn = Expression<Int>("coins_after_txn")
        let coins_before_txn = Expression<Int>("coins_before_txn")
        let total_coins = Expression<Int>("total_coins")
        let xp = Expression<Int>("xp")
        let amount = Expression<Int>("amount")
        let coins = Expression<Int>("coins")
        let status = Expression<String>("status")
        let platform_version = Expression<String>("platform_version")
        let txn_type = Expression<String>("txn_type")
        let updated_at = Expression<String>("updated_at")
        let created_at = Expression<String>("created_at")
        let quantity = Expression<Int>("quantity")
        let package_price = Expression<Int>("package_price")
        let platform = Expression<String>("platform")
        let entity_id = Expression<String>("entity_id")
        let entity = Expression<String>("entity")
        let passbook_applied = Expression<Bool>("passbook_applied")
        
        
        let thumb = Expression<String>("thumb")
        let caption = Expression<String>("caption")
        let type = Expression<String>("type")
        let video = Expression<String>("video")
        let name = Expression<String>("name")
        let audio = Expression<String>("audio")
        let description = Expression<String>("description")
        let vendor_txn_id = Expression<String>("vendor_txn_id")
        let currency_code = Expression<String>("currency_code")
        let transaction_price = Expression<Double>("transaction_price")
        let vendor = Expression<String>("vendor")
        
        // ARTIST
        let first_name = Expression<String>("first_name")
        let last_name = Expression<String>("last_name")
        do{
            let insert = PassbookTable.insert( _id <- transaction._id ?? "" , coins_after_txn <- transaction.coins_after_txn ?? 0 ,   coins_before_txn <- transaction.coins_before_txn ?? 0 ,  total_coins <- transaction.total_coins ?? 0 ,  xp <- transaction.xp ?? 0 ,  amount <- transaction.amount ?? 0,  coins <- transaction.coins ?? 0,  status <- transaction.status ?? "" , platform_version <- transaction.platform_version ?? "" , txn_type <- transaction.txn_type ?? "" ,updated_at <- transaction.updated_at ?? "", created_at <- transaction.created_at ?? "" , quantity <- transaction.quantity ?? 0, package_price <- transaction.package_price ?? 0, platform <- transaction.platform ?? "", entity_id <- transaction.entity_id ?? "",  entity <- transaction.entity ?? "", passbook_applied <- transaction.passbook_applied ?? false,
                                               
                                               thumb <- transaction.metaInfo?.thumb ?? "" , caption <- transaction.metaInfo?.caption ?? "" ,
                                               type <- transaction.metaInfo?.type ?? "" , video <- transaction.metaInfo?.video ?? "" ,
                                               name <- transaction.metaInfo?.name ?? "" , audio <- transaction.metaInfo?.audio ?? "" ,
                                               description <- transaction.metaInfo?.description ?? "" , description <- transaction.metaInfo?.description ?? "" ,
                                               vendor_txn_id <- transaction.metaInfo?.vendor_txn_id ?? "" , currency_code <- transaction.metaInfo?.currency_code ?? "" ,
                                               transaction_price <- transaction.metaInfo?.transaction_price ?? 0.0 , vendor <- transaction.metaInfo?.vendor ?? "",
                                               
                                               first_name <- transaction.artist?.first_name ?? "" , last_name <- transaction.artist?.last_name ?? ""
                
            )
            
//            try db.run(insert)
            print("Passbook db.run insert id = \(try db.run(insert))")
            if (transaction._id != nil) {
                self.createPassbookTable()
                self.insertIntoPassbook(transaction: transaction)
            }
        }catch{
            
        }
    }
    
    func getFormPassbook() -> [LedgerTransaction]{
        print("Passbook getFormPassbook")
        var transactions = [LedgerTransaction]()
        let _id = Expression<String>("_id")
        let coins_after_txn = Expression<Int>("coins_after_txn")
        let coins_before_txn = Expression<Int>("coins_before_txn")
        let total_coins = Expression<Int>("total_coins")
        let xp = Expression<Int>("xp")
        let amount = Expression<Int>("amount")
        let coins = Expression<Int>("coins")
        let status = Expression<String>("status")
        let platform_version = Expression<String>("platform_version")
        let txn_type = Expression<String>("txn_type")
        let updated_at = Expression<String>("updated_at")
        let created_at = Expression<String>("created_at")
        let quantity = Expression<Int>("quantity")
        let package_price = Expression<Int>("package_price")
        let platform = Expression<String>("platform")
        let entity_id = Expression<String>("entity_id")
        let entity = Expression<String>("entity")
        let passbook_applied = Expression<Bool>("passbook_applied")
        
        let thumb = Expression<String>("thumb")
        let caption = Expression<String>("caption")
        let type = Expression<String>("type")
        let video = Expression<String>("video")
        let name = Expression<String>("name")
        let audio = Expression<String>("audio")
        let description = Expression<String>("description")
        let vendor_txn_id = Expression<String>("vendor_txn_id")
        let currency_code = Expression<String>("currency_code")
        let transaction_price = Expression<Double>("transaction_price")
        let vendor = Expression<String>("vendor")
        
        // ARTIST
        let first_name = Expression<String>("first_name")
        let last_name = Expression<String>("last_name")
        do{
            if self.tableExists(tableName: "Passbook") {
                print("Passbook tableExists")
                for transactionData in try db.prepare(PassbookTable) {
                    print("Passbook transactionData = \(transactionData)")
                    let returnTransaction : LedgerTransaction = LedgerTransaction(dict: NSDictionary.init() as! [String : Any])
                    returnTransaction._id = transactionData[_id]
                    returnTransaction.coins_after_txn = transactionData[coins_after_txn]
                    returnTransaction.coins_before_txn = transactionData[coins_before_txn]
                    returnTransaction.total_coins = transactionData[total_coins]
                    returnTransaction.xp = transactionData[xp]
                    returnTransaction.amount = transactionData[amount]
                    returnTransaction.coins = transactionData[coins]
                    returnTransaction.status = transactionData[status]
                    returnTransaction.coins = transactionData[coins]
                    returnTransaction.platform_version = transactionData[platform_version]
                    returnTransaction.status = transactionData[status]
                    returnTransaction.txn_type = transactionData[txn_type]
                    returnTransaction.updated_at = transactionData[updated_at]
                    
                    returnTransaction.created_at = transactionData[created_at]
                    returnTransaction.quantity = transactionData[quantity]
                    returnTransaction.package_price = transactionData[package_price]
                    returnTransaction.platform = transactionData[platform]
                    returnTransaction.entity_id = transactionData[entity_id]
                    returnTransaction.entity = transactionData[entity]
                    returnTransaction.passbook_applied = transactionData[passbook_applied]
                    
                    let metaInfo:LT_Meta_Info = LT_Meta_Info(dict: NSDictionary.init() as? [String : Any])
                    metaInfo.thumb = transactionData[thumb]
                    metaInfo.caption = transactionData[caption]
                    metaInfo.type = transactionData[type]
                    metaInfo.video = transactionData[video]
                    metaInfo.name = transactionData[name]
                    metaInfo.audio = transactionData[audio]
                    metaInfo.description = transactionData[description]
                    metaInfo.vendor_txn_id = transactionData[vendor_txn_id]
                    metaInfo.currency_code = transactionData[currency_code]
                    metaInfo.transaction_price = transactionData[transaction_price]
                    metaInfo.vendor = transactionData[vendor]
                    returnTransaction.metaInfo = metaInfo;
                    
                    let artist = Artist(dict: NSDictionary.init() as? [String : Any])
                    artist.first_name = transactionData[first_name]
                    artist.last_name = transactionData[last_name]
                    returnTransaction.artist = artist
                    transactions.append(returnTransaction)
                }
            } else {
                print("Passbook table not Exists")
            }
        }catch let error {
            print("Passbook Exception")
             print("\(#function) error \(error.localizedDescription)")
        }
        return transactions
    }
    
    
    func createSpendingGiftTable() {
        
        let _id =  Expression<String>("_id")
        let type = Expression<String>("type")
        let name =  Expression<String>("name")
        let coins =  Expression<Int>("coins")
        let photo =  Expression<String>("photo")
        let spendingId = Expression<String>("spendingId")
        
        do{
            try db.run(SpendingGift.create(ifNotExists: true) { t in
                t.column(_id)
                t.column(type)
                t.column(name)
                t.column(coins)
                t.column(photo)
                t.column(spendingId)
                
            })
            
        }catch{
            
            
        }
    }
    func insertIntoSpendingGift(spendings : Spending) {
        let _id =  Expression<String>("_id")
        let type = Expression<String>("type")
        let name =  Expression<String>("name")
        let coins =  Expression<Int>("coins")
        let photo =  Expression<String>("photo")
        let spendingId = Expression<String>("spendingId")
        
        do{
            
            let insert = SpendingGift.insert( _id <- (spendings.gift?.id) ?? "" , type <- spendings.gift?.type ?? "" , name <- spendings.gift?.name ?? "", coins <- spendings.gift?.coins ?? 0 , photo <- spendings.gift?.spendingPhoto?.thumb ?? ""  , spendingId <- spendings.id ?? "")
            
            try db.run(insert)
            
        }catch{
            
        }
        
    }
    func getSpendingGift(spending : String ) -> Gift{
        
        let gift = Gift(dict: NSDictionary.init() as! [String : Any])
        let _id =  Expression<String>("_id")
        let type = Expression<String>("type")
        let name =  Expression<String>("name")
        let coins =  Expression<Int>("coins")
        let photo =  Expression<String>("photo")
        let spendingId = Expression<String>("spendingId")
        do{
            
            if self.tableExists(tableName: "SpendingGift") {
                let querySocial = SpendingGift.filter(spendingId == spending)
                
                for giftData in try db.prepare(SpendingGift) {
                    
                    gift.id = giftData[_id]
                    gift.type = giftData[type]
                    gift.name = giftData[name]
                    gift.coins = giftData[coins]
                    let photoObj = Photo.init(dict: ["cover" : giftData[photo]])
                    gift.photo = photoObj
                }
            }
        }catch{
            
        }
        return gift
    }
    
    
    func createSpendingTable() {
        
        
        //        var gift: Gift?
        //
        //        var content:Content?
        
        let _id = Expression<String>("_id")
        let coins = Expression<Int>("coins")
        let created_at = Expression<String>("created_at")
        let entity_id = Expression<String>("entity_id")
        let coins_before_purchase = Expression<Int>("coins_before_purchase")
        let coins_after_purchase = Expression<Int>("coins_after_txn")
        let coin_of_one = Expression<Int>("coin_of_one")
        let total_quantity = Expression<Int>("total_quantity")
        let entity = Expression<String>("entity")
        let artist_id = Expression<String>("artist_id")
        let customer_id = Expression<Int>("customer_id")
        let content = Expression<String>("content")
        let updated_at = Expression<String>("updated_at")
        let spending_type = Expression<String>("type")
        
        
        do{
            try db.run(SpendingTable.create(ifNotExists: true) { t in
                t.column(_id, primaryKey: true)
                t.column(created_at)
                t.column(entity)
                t.column(entity_id)
                t.column(coins_after_purchase)
                t.column(coins_before_purchase)
                t.column(coins)
                t.column(coin_of_one)
                t.column(total_quantity)
                t.column(artist_id)
                t.column(customer_id)
                t.column(content)
                t.column(updated_at)
                t.column(spending_type)
            })
            
        }catch{
            
            
        }
        
    }
    func insertIntoSpending(spendingData : Spending)
    {
        let _id = Expression<String>("_id")
        let coins = Expression<Int>("coins")
        let created_at = Expression<String>("created_at")
        let entity_id = Expression<String>("entity_id")
        let coins_before_purchase = Expression<Int>("coins_before_purchase")
        let coins_after_purchase = Expression<Int>("coins_after_txn")
        let coin_of_one = Expression<Int>("coin_of_one")
        let total_quantity = Expression<Int>("total_quantity")
        let entity = Expression<String>("entity")
        let artist_id = Expression<String>("artist_id")
        let customer_id = Expression<String>("customer_id")
        let content = Expression<String>("content")
        let updated_at = Expression<String>("updated_at")
        let spending_type = Expression<String>("type")
        do{
            let insert = SpendingTable.insert( _id <- spendingData.id ?? "" , created_at <- spendingData.created_at ?? "" ,   entity_id <- spendingData.entity_id ?? "" ,  coins_before_purchase <- spendingData.coins_before_purchase ?? 0 ,  coins_after_purchase <- spendingData.coins_after_purchase ?? 0 ,  coin_of_one <- spendingData.coin_of_one ?? 0,  total_quantity <- spendingData.total_quantity ?? 0,  customer_id <- spendingData.customer_id ?? "" , artist_id <- spendingData.artist_id ?? "" , content <- spendingData.content?.photo?.cover ?? "" ,coins <- spendingData.coins ?? 0,entity <- spendingData.entity ?? "" , updated_at <- spendingData.updated_at ?? "",spending_type <- spendingData.spending_type ?? "", content <- spendingData.content?.slug ?? "")
            
            try db.run(insert)
            if (spendingData.gift?.id != nil) {
                self.createSpendingGiftTable()
                self.insertIntoSpendingGift(spendings: spendingData)
            }
            
            
        }catch{
            
        }
        
        
    }
    
    func getFormSpending() -> [Spending]{
        
        
        var spendings = [Spending]()
        let _id = Expression<String>("_id")
        let coins = Expression<Int>("coins")
        let created_at = Expression<String>("created_at")
        let entity_id = Expression<String>("entity_id")
        let coins_before_purchase = Expression<Int>("coins_before_purchase")
        let coins_after_purchase = Expression<Int>("coins_after_txn")
        let coin_of_one = Expression<Int>("coin_of_one")
        let total_quantity = Expression<Int>("total_quantity")
        let entity = Expression<String>("entity")
        let artist_id = Expression<String>("artist_id")
        let customer_id = Expression<String>("customer_id")
        let content = Expression<String>("content")
        let updated_at = Expression<String>("updated_at")
        let spending_type = Expression<String>("type")
        //
        let id = Expression<String>("_id")
        let spendingId = Expression<String>("spendingId")
        let type = Expression<String>("type")
        let name =  Expression<String>("name")
        let photo =  Expression<String>("photo")
        ///
        do{
            if self.tableExists(tableName: "Spending") {
                
                for purchaseData in try db.prepare(SpendingTable) {
                    let returnPurchase : Spending = Spending(dict: NSDictionary.init() as! [String : Any])
                    
                    returnPurchase.id = purchaseData[_id]
                    returnPurchase.created_at = purchaseData[created_at]
                    returnPurchase.coin_of_one = purchaseData[coin_of_one]
                    returnPurchase.entity = purchaseData[entity]
                    returnPurchase.entity_id = purchaseData[entity_id]
                    returnPurchase.coins_after_purchase = purchaseData[coins_after_purchase]
                    returnPurchase.coins_before_purchase = purchaseData[coins_before_purchase]
                    returnPurchase.total_quantity = purchaseData[total_quantity]
                    returnPurchase.coins = purchaseData[coins]
                    returnPurchase.artist_id = purchaseData[artist_id]
                    returnPurchase.customer_id = purchaseData[customer_id]
                    returnPurchase.updated_at = purchaseData[updated_at]
                    returnPurchase.spending_type = purchaseData[spending_type]
                    let photoDict = ["cover" : purchaseData[content]]
                    let content : Content = Content(dict: ["photo" : photoDict])
                    returnPurchase.content  = content
                    let slug : Content = Content(dict: ["slug" : photoDict])
                    returnPurchase.content  = slug
                    
                    
                    let query = SpendingGift.filter(spendingId  == returnPurchase.id!)
                    let gift = Gift(dict: NSDictionary.init() as! [String : Any])
                    for giftData in try db.prepare(query) {
                        
                        gift.id = giftData[_id]
                        gift.type = giftData[type]
                        gift.name = giftData[name]
                        gift.coins = giftData[coins]
                        
                        let photoObj = SpendingOnPhoto.init(dict: ["thumb" : giftData[photo]])
                        gift.spendingPhoto = photoObj
                    }
                    returnPurchase.gift = gift
                    spendings.append(returnPurchase)
                }
            }
            
        }catch{
            
            
        }
        return spendings
    }
    
    func createRewardsTable() {
        
        let reward_title = Expression<String>("reward_title")
        let _id = Expression<String>("_id")
        let updated_at = Expression<String>("updated_at")
        let reward_type = Expression<String>("reward_type")
        let coins = Expression<Int>("coins")
        let created_at = Expression<String>("created_at")
        let description = Expression<String>("description")
        let title = Expression<String>("title")
        let customer_id = Expression<String>("customer_id")
        let artist_id = Expression<String>("artist_id")
        let photo = Expression<String>("photo")
        
        
        do{
            try db.run(RewardsTable.create(ifNotExists: true) { t in
                t.column(_id, primaryKey: true)
                t.column(created_at)
                t.column(updated_at)
                t.column(reward_type)
                t.column(reward_title)
                t.column(description)
                t.column(coins)
                t.column(title)
                t.column(artist_id)
                t.column(customer_id)
                t.column(photo)
                
            })
            
        }catch{
            
            
        }
    }
    func insertIntoReward( reward : Rewards) {
        let reward_title = Expression<String>("reward_title")
        let _id = Expression<String>("_id")
        let updated_at = Expression<String>("updated_at")
        let reward_type = Expression<String>("reward_type")
        let coins = Expression<Int>("coins")
        let created_at = Expression<String>("created_at")
        let description = Expression<String>("description")
        let title = Expression<String>("title")
        let customer_id = Expression<String>("customer_id")
        let artist_id = Expression<String>("artist_id")
        let photo = Expression<String>("photo")
        
        do{
            let insert = RewardsTable.insert(_id <-  reward._id ?? "" , reward_title <- reward.reward_title ?? "" , title <- reward.title ?? "" , reward_type <- reward.reward_type ?? "" , coins <- reward.coins ?? 0, customer_id <- reward.customer_id ?? "", artist_id <- reward.artist_id ?? "", updated_at <- reward.updated_at ?? "" , created_at <- reward.created_at ?? "", description <- reward.description ?? "", photo <- reward.artist?.cover?.thumb ?? "" )
            try db.run(insert)
            
        }catch{
            
        }
        
    }
    func getRewards() -> [Rewards] {
        
        var rewardArray  = [Rewards]()
        let reward_title = Expression<String>("reward_title")
        let _id = Expression<String>("_id")
        let updated_at = Expression<String>("updated_at")
        let reward_type = Expression<String>("reward_type")
        let coins = Expression<Int>("coins")
        let created_at = Expression<String>("created_at")
        let description = Expression<String>("description")
        let title = Expression<String>("title")
        let customer_id = Expression<String>("customer_id")
        let artist_id = Expression<String>("artist_id")
        let photo = Expression<String>("photo")
        
        do{
            
            if self.tableExists(tableName: "Rewards") {
                //exists
                for purchaseData in try db.prepare( RewardsTable) {
                    
                    let returnPurchase : Rewards = Rewards(dict: NSDictionary.init() as! [String : Any])
                    
                    returnPurchase._id = purchaseData[_id]
                    returnPurchase.updated_at = purchaseData[updated_at]
                    returnPurchase.created_at = purchaseData[created_at]
                    returnPurchase.reward_title = purchaseData[reward_title]
                    returnPurchase.reward_type = purchaseData[reward_type]
                    returnPurchase.coins = purchaseData[coins]
                    returnPurchase.description = purchaseData[description]
                    returnPurchase.title = purchaseData[title]
                    returnPurchase.customer_id = purchaseData[customer_id]
                    returnPurchase.artist_id = purchaseData[artist_id]
                    let dict = ["cover" : ["thumb" : purchaseData[photo]]]
                    let artist = Artist(dict: dict)
                    returnPurchase.artist = artist
                    rewardArray.append(returnPurchase)
                }
            }
            
        }catch{
            
            
        }
        return rewardArray
    }
    
    func createLeaderboardTable() {
        
        let _id  = Expression<String>("_id")
        let identity = Expression<String>("identity")
        let last_name = Expression<String>("last_name")
        let first_name = Expression<String>("first_name")
        let email = Expression<String>("email")
        let picture = Expression<String>("picture")
        let badgeName = Expression<String>("badgeName")
        let badgeIcon = Expression<String>("badgeIcon")
        
        do{
            try db.run(FavFans.create(ifNotExists: true) { t in
                t.column(_id, primaryKey: true)
                t.column(identity)
                t.column(first_name)
                t.column(last_name)
                t.column(email)
                t.column(picture)
                t.column(badgeName)
                t.column(badgeIcon)
            })
            
        }catch{
            
        }
        
    }
    func insertIntoFansTable( user : Users ) {
        let _id  = Expression<String>("_id")
        let identity = Expression<String>("identity")
        let last_name = Expression<String>("last_name")
        let first_name = Expression<String>("first_name")
        let email = Expression<String>("email")
        let picture = Expression<String>("picture")
        let badgeName = Expression<String>("badgeName")
        let badgeIcon = Expression<String>("badgeIcon")
        
        do{
            let insert = FavFans.insert( _id <- user.id ?? "" , identity <- user.identity ?? "" , first_name <- user.first_name ?? "", last_name <- user.last_name ?? "" , email <- user.email ?? "" , picture <- user.picture ?? "" , badgeName <- user.badgeName ?? ""  , badgeIcon <- user.badgeIcon ?? "")
            try db.run(insert)
            
        }catch let error{
            
             print("\(#function) error \(error.localizedDescription)")
        }
        
    }
    func getFanOfMonth() -> Users{
        
        let returnPurchase : Users = Users(dict: NSDictionary.init() as! [String : Any])
        
        
        let _id  = Expression<String>("_id")
        let identity = Expression<String>("identity")
        let last_name = Expression<String>("last_name")
        let first_name = Expression<String>("first_name")
        let email = Expression<String>("email")
        let picture = Expression<String>("picture")
        let badgeName = Expression<String>("badgeName")
        let badgeIcon = Expression<String>("badgeIcon")
        
        do{
            if self.tableExists(tableName: "FavFans") {
                let query = FavFans.filter(badgeName == "fan of month")
                
                for purchaseData in try db.prepare(query) {
                    returnPurchase.id = purchaseData[_id]
                    returnPurchase.identity = purchaseData[identity]
                    returnPurchase.first_name = purchaseData[first_name]
                    returnPurchase.last_name = purchaseData[last_name]
                    returnPurchase.email = purchaseData[email]
                    returnPurchase.picture = purchaseData[picture]
                    returnPurchase.badgeIcon = purchaseData[badgeIcon]
                    returnPurchase.badgeName = purchaseData[badgeName]
                }
            }
            
        }catch{
            
            
        }
        return returnPurchase
    }
    
    
    func getFansData() -> [Users] {
        
        var usersArray = [Users]()
        
        let _id  = Expression<String>("_id")
        let identity = Expression<String>("identity")
        let last_name = Expression<String>("last_name")
        let first_name = Expression<String>("first_name")
        let email = Expression<String>("email")
        let picture = Expression<String>("picture")
        let badgeName = Expression<String>("badgeName")
        let badgeIcon = Expression<String>("badgeIcon")
        
        do{
            if self.tableExists(tableName: "FavFans") {
                let query = FavFans.filter(badgeName != "fan of month")
                
                for purchaseData in try db.prepare(query) {
                    
                    let returnPurchase : Users = Users(dict: NSDictionary.init() as! [String : Any])
                    
                    returnPurchase.id = purchaseData[_id]
                    returnPurchase.identity = purchaseData[identity]
                    returnPurchase.first_name = purchaseData[first_name]
                    returnPurchase.last_name = purchaseData[last_name]
                    returnPurchase.email = purchaseData[email]
                    returnPurchase.picture = purchaseData[picture]
                    returnPurchase.badgeIcon = purchaseData[badgeIcon]
                    returnPurchase.badgeName = purchaseData[badgeName]
                    
                    usersArray.append(returnPurchase)
                }
            }
            
        }catch{
            
            
        }
        return usersArray
    }
    
    func createHideTable() {
        let contentId = Expression<String>("contentId")
        let customerId   = Expression<String>("customerId")
        
        do{
            try db.run(HideContent.create(ifNotExists: true) { t in
                t.column(contentId, primaryKey: true)
                t.column(customerId)
                
            })
            
        }catch{
            
            
            
        }
        
    }
    func insertIntoHideContent(content : String, customer : String) {
        let contentId = Expression<String?>("contentId")
        let customerId   = Expression<String>("customerId")
        do{
            let insert = HideContent.insert(contentId <- content, customerId <- customer)
            try db.run(insert)
            
        }catch{
            
        }
        
    }
    func getHideContents() {
        let contentId = Expression<String?>("contentId")
        do{
            var hideContents = [String]()
            if self.tableExists(tableName: "HideContent") {
                for likes in try db.prepare(HideContent) {
                    hideContents.append(likes[contentId]!)
                }
                if (hideContents != nil && CustomerDetails.customerData != nil) {
                    
                    CustomerDetails.customerData.hide_content_ids = hideContents
                }
            }
        }catch{
            
        }
        
    }
    func createBadgesTable() {
        let customer_id = Expression<String?>("customer_id")
        let name = Expression<String>("name")
        let level = Expression<Int?>("level")
        let icon = Expression<String?>("icon")
        let status = Expression<String?>("status")
        
        
        do{
            try db.run(Badges.create(ifNotExists: true) { t in
                t.column(name, primaryKey: true)
                t.column(level)
                t.column(icon)
                t.column(status)
                t.column(customer_id)
                
            })
            
        }catch{
            
            
            
        }
        
    }
    func createCommentsTable() {
        
        let commentId = Expression<String>("commentId")
        let postId = Expression<String>("postId")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let picture = Expression<String>("picture")
        let comment = Expression<String>("comment")
        let entityId = Expression<String>("entityId")
        let replies = Expression<Int>("replies")
        let created_at = Expression<Date>("created_at")
        let types = Expression<String>("type")
        
        let date_diff_for_human = Expression<String>("date_diff_for_human")
        
        do{
            try db.run(CommentTable.create(ifNotExists: true) { t in
                t.column(commentId, primaryKey: true)
                t.column(firstName )
                t.column(lastName)
                t.column(picture)
                t.column(comment)
                t.column(postId)
                t.column(entityId)
                t.column(replies)
                t.column(date_diff_for_human)
                t.column(created_at)
                t.column(types)
                
            })
            
        }catch let error{
            
             print("\(#function) error \(error.localizedDescription)")
        }
    }
    func insertIntoComments(commentObj : Comments) {
        
        let commentId = Expression<String>("commentId")
        let postId = Expression<String>("postId")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let picture = Expression<String>("picture")
        let comment = Expression<String>("comment")
        let replies = Expression<Int>("replies")
        let entityId = Expression<String>("entityId")
        let created_at = Expression<Date>("created_at")
        let types = Expression<String>("type")
        let date_diff_for_human = Expression<String>("date_diff_for_human")
        
        do{
            let insert = CommentTable.insert(or: OnConflict.replace,[commentId <- commentObj._id ?? "" , postId <- commentObj.contentId ?? "", firstName <- commentObj.user?.first_name ?? "" , lastName <- commentObj.user?.last_name ?? "" , picture <- commentObj.user?.picture ?? "", comment <- commentObj.comment ?? "", replies <- commentObj.stats?.replies ?? 0 , entityId <- commentObj.entityId ?? "", date_diff_for_human <- commentObj.date_diff_for_human ?? "",created_at <- commentObj.created_at! , types <- commentObj.types ?? ""])
            try db.run(insert)
            
        }catch let error{
            
             print("\(#function) error \(error.localizedDescription)")
        }
        
    }
    func getCommentsData(comment_id : String) ->  [Comments]{
        
        var commentsArray : [Comments] = [Comments]()
        
        if (self.db != nil) {
            
            let commentId = Expression<String>("commentId")
            let postId = Expression<String>("postId")
            let firstName = Expression<String>("firstName")
            let lastName = Expression<String>("lastName")
            let picture = Expression<String>("picture")
            let comment = Expression<String>("comment")
            let replies = Expression<Int>("replies")
            let entityId = Expression<String>("entityId")
            let created_at = Expression<Date>("created_at")
            let types = Expression<String>("type")
            let date_diff_for_human = Expression<String>("date_diff_for_human")
            
            var commentObj : Comments!
            
            do{
                if self.tableExists(tableName: "Comment") {
                    let queryVideo = CommentTable.filter(postId == comment_id)
                    
                    for commentRow in try db.prepare(queryVideo .order([created_at.desc])) {
                        let dictionary = NSDictionary.init()
                        commentObj = Comments(dict:dictionary as! [String : Any])
                        commentObj._id = commentRow[commentId]
                        commentObj.contentId = commentRow[postId]
                        commentObj.comment =  commentRow[comment]
                        commentObj.types =  commentRow[types]
                        commentObj.date_diff_for_human = commentRow[date_diff_for_human]
                        commentObj.entityId = commentRow[entityId]
                        let userDict = ["first_name" : commentRow[firstName],"last_name" : commentRow[lastName] ,"picture" : commentRow[picture]]
                        commentObj.user = Users(dict: userDict)
                        commentObj.stats  = Stats(dictionary: ["replies": commentRow[replies]])
                        commentObj.stats?.replies = commentRow[replies]
                        
                        commentObj.created_at = commentRow[created_at]
                        commentsArray.append(commentObj)
                    }
                }
            }catch let error{
                
                 print("\(#function) error \(error.localizedDescription)")
            }
        }
        return commentsArray
    }
    
    func createRepliesTable() {
        
        let commentId = Expression<String>("commentId")
        let parentId = Expression<String>("parentId")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let picture = Expression<String>("picture")
        let comment = Expression<String>("comment")
        let entityId = Expression<String>("entityId")
        let created_at = Expression<Date>("created_at")
        let types = Expression<String>("type")
        let date_diff_for_human = Expression<String>("date_diff_for_human")
        
        do{
            try db.run(ReplyTable.create(ifNotExists: true) { t in
                t.column(commentId, primaryKey: true)
                t.column(firstName)
                t.column(lastName)
                t.column(picture)
                t.column(comment)
                t.column(parentId)
                t.column(entityId)
                t.column(date_diff_for_human)
                t.column(created_at)
                t.column(types)
            })
            
        }catch{
            
        }
    }
    func insertIntoReply(commentObj : Reply) {
        
        let commentId = Expression<String>("commentId")
        let parentId = Expression<String>("parentId")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let picture = Expression<String>("picture")
        let comment = Expression<String>("comment")
        let entityId = Expression<String>("entityId")
        let created_at = Expression<Date>("created_at")
        let types = Expression<String>("type")
        let date_diff_for_human = Expression<String>("date_diff_for_human")
        
        do{
            if (commentObj._id != nil) {
                let insert = ReplyTable.insert(or: OnConflict.replace,[commentId <- commentObj._id ?? "" , parentId <- commentObj.parentId ?? "", firstName <- commentObj.user?.first_name ?? "" , lastName <- commentObj.user?.last_name ?? "" , picture <- commentObj.user?.picture ?? "", comment <- commentObj.comment ?? "" , entityId <- commentObj.entityId ?? "", date_diff_for_human <- commentObj.date_diff_for_human ?? "", created_at <- commentObj.created_at!, types <- commentObj.types ?? ""])
                try db.run(insert)
            }
            
        }catch let error{
            
             print("\(#function) error \(error.localizedDescription)")
        }
        
    }
    func getReplyData(comment_Id : String) ->  [Reply]{
        
        var commentsArray : [Reply] = [Reply]()
        
        if (self.db != nil) {
            
            let commentId = Expression<String>("commentId")
            let firstName = Expression<String>("firstName")
            let lastName = Expression<String>("lastName")
            let picture = Expression<String>("picture")
            let comment = Expression<String>("comment")
            let entityId = Expression<String>("entityId")
            let parentId = Expression<String>("parentId")
            let created_at = Expression<Date>("created_at")
            let types = Expression<String>("type")
            let date_diff_for_human = Expression<String>("date_diff_for_human")
            
            var commentObj : Reply!
            
            do{
                if self.tableExists(tableName: "Reply") {
                    
                    let queryVideo = ReplyTable.filter(parentId == comment_Id)
                    
                    for commentRow in try db.prepare(queryVideo) {
                        let dictionary = NSDictionary.init()
                        commentObj = Reply(dict:dictionary as! [String : Any])
                        commentObj._id = commentRow[commentId]
                        commentObj.parentId = commentRow[parentId]
                        commentObj.comment =  commentRow[comment]
                        commentObj.entityId = commentRow[entityId]
                        commentObj.types =  commentRow[types]
                        commentObj.date_diff_for_human = commentRow[date_diff_for_human]
                        let userDict = ["first_name" : commentRow[firstName],"last_name" : commentRow[lastName] ,"picture" : commentRow[picture]]
                        commentObj.user = Users(dict: userDict)
                        commentObj.created_at = commentRow[created_at]
                        //                    commentObj.stats  = Stats(dictionary: ["replies": commentRow[replies]])
                        commentsArray.append(commentObj)
                    }
                }
            }catch let error{
                
                 print("\(#function) error \(error.localizedDescription)")
            }
        }
        return commentsArray
    }
    
    func createContentsLikeTable() {
        let id = Expression<String>("id")
        do{
            try db.run(ContentLikes.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
            })
            
        }catch{
            
        }
    }
    
    func insertIntoContentLikesTable(likeId : String) {
        let id = Expression<String>("id")
        
        do{
            let insert = ContentLikes.insert(id <- likeId)
            try db.run(insert)
            
        }catch{
            
        }
        
    }
    func insertIntoContentPurchaseTable(purchaseId : String ) {
        let id = Expression<String>("id")
        
        do{
            let insert = ContentPurchase.insert(id <- purchaseId)
            try db.run(insert)
            
        }catch{
            
        }
        
    }
    func getContentLikesData() {
        
        let id = Expression<String>("id")
        do{
            var likesIds = [String]()
            if self.tableExists(tableName: "ContentLikes") {
                for likes in try db.prepare(ContentLikes) {
                    likesIds.append(likes[id])
                }
                if (likesIds != nil && CustomerDetails.customerData != nil) {
                    CustomerDetails.customerData.like_content_ids = likesIds
                }
            }
        }catch{
            
        }
        
    }
    
    func getContentPurchaseData() {
        let id = Expression<String>("id")
        do{
            var likesIds = [String]()
            if self.tableExists(tableName: "ContentPurchase") {
                
                for likes in try db.prepare(ContentPurchase) {
                    likesIds.append(likes[id])
                }
                if (likesIds != nil && CustomerDetails.customerData != nil) {
                    
                    CustomerDetails.customerData.purchase_content_ids = likesIds
                }
            }
        }catch{
            
        }
        
    }
    
    func createContentsPurchaseTable() {
        let id = Expression<String>("id")
        do{
            try db.run(ContentPurchase.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
            })
            
        }catch{
            
        }
    }
    func createCustomerTable() {
        
        let id = Expression<String>("id")
        let first_name = Expression<String?>("first_name")
        let last_name = Expression<String?>("last_name")
        let email = Expression<String?>("email")
        let device_id = Expression<String?>("device_id")
        let segment_id = Expression<Int?>("segment_id")
        let fcm_id = Expression<String?>("fcm_id")
        let platform = Expression<String?>("platform")
        let badges = Expression<String?>("badges")
        let account_link = Expression<String?>("account_link")
        let status = Expression<String?>("status")
        let updated_at = Expression<String?>("updated_at")
        let created_at = Expression<String?>("created_at")
        let last_visited = Expression<String?>("last_visited")
        let picture = Expression<String?>("picture")
        let coins = Expression<Int?>("coins")
        let xp = Expression<Int?>("xp")
        let mobile = Expression<String?>("mobile")
        let gender = Expression<String?>("gender")
        let purchaseStickers = Expression<Bool?>("purchase_stickers")
        let identity = Expression<String?>("identity")
        let directline_room_id = Expression<String?>("directline_room_id")
        do{
            try db.run(CustomerProfile.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(first_name)
                t.column(last_name)
                t.column(platform)
                t.column(coins)
                t.column(purchaseStickers)
                t.column(email)
                t.column(device_id)
                t.column(segment_id)
                t.column(fcm_id)
                t.column(xp)
                t.column(status)
                t.column(last_visited)
                t.column(picture)
                t.column(created_at)
                t.column(updated_at)
                t.column(account_link)
                t.column(badges)
                t.column(mobile)
                t.column(gender)
                t.column(identity)
                t.column(directline_room_id)
            })
            
        }catch{
            
            
            
        }
        
    }
    
    func insertCustomerDataToDatabase(cust: Customer) {
        
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        if (database != nil) {
            database.createCustomerTable()
        }
        database.insertIntoCustomer(customer: cust)
    }
    
    func storeLikesAndPurchase(like_ids : [String], purchaseIds : [String], block_ids : [String]?) {
        
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        if (database != nil) {
            database.createContentsLikeTable()
            
            if (like_ids != nil && like_ids.count > 0) {
                
                for var id in like_ids{
                    
                    database.insertIntoContentLikesTable(likeId: id)
                }
                
            }
            
            database.createContentsPurchaseTable()
            if (purchaseIds != nil && purchaseIds.count > 0) {
                
                for var purchase in purchaseIds{
                    database.insertIntoContentPurchaseTable(purchaseId :purchase )
                }
                
            }
            database.createHideTable()
            database.createContentspurchaseLiveidsTable()
            if (block_ids != nil) {
                if (block_ids!.count > 0) {
                    
                    for var blockId in block_ids!{
                        database.insertIntoHideContent(content: blockId , customer: "" )
                    }
                    
                }
            }
        }
        
    }
    
    func storeLikesAndPurchase( purchaseIds : [String], block_ids : [String]?) {
        
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        if (database != nil) {
            database.createContentsLikeTable()
            
            
            database.createContentsPurchaseTable()
            if (purchaseIds != nil && purchaseIds.count > 0) {
                
                for var purchase in purchaseIds{
                    database.insertIntoContentPurchaseTable(purchaseId :purchase )
                }
                
            }
            database.createHideTable()
            if (block_ids != nil) {
                if (block_ids!.count > 0) {
                    
                    for var blockId in block_ids!{
                        database.insertIntoHideContent(content: blockId , customer: "" )
                    }
                    
                }
            }
        }
        
    }
    
    func insertIntoCustomer(customer : Customer) {
        
        do{
            
            let id = Expression<String>("id")
            let first_name = Expression<String?>("first_name")
            let last_name = Expression<String?>("last_name")
            let email = Expression<String?>("email")
            let device_id = Expression<String?>("device_id")
            let segment_id = Expression<Int?>("segment_id")
            let fcm_id = Expression<String?>("fcm_id")
            let platform = Expression<String?>("platform")
            let badges = Expression<String?>("badges")
            let account_link = Expression<String?>("account_link")
            let status = Expression<String?>("status")
            let updated_at = Expression<String?>("updated_at")
            let created_at = Expression<String?>("created_at")
            let last_visited = Expression<String?>("last_visited")
            let picture = Expression<String?>("picture")
            let xp = Expression<Int?>("xp")
            let coins = Expression<Int?>("coins")
            let mobile = Expression<String?>("mobile")
            let gender = Expression<String?>("gender")
            let purchase_stickers = Expression<Bool?>("purchase_stickers")
            let identity = Expression<String?>("identity")
            let directline_room_id = Expression<String?>("directline_room_id")

            let insert = CustomerProfile.insert(or: OnConflict.replace, [first_name <- customer.first_name ?? "" , last_name <- customer.last_name ?? "" , id <- customer._id ?? "" , coins <- customer.coins ?? 0 ,device_id <- customer.device_id ?? "", xp <- customer.xp  ?? 0, status <- customer.status ?? "", platform <- customer.platform ?? "" , last_visited <- customer.last_visited ?? "", email <- customer.email ?? "", segment_id <- customer.segment_id ?? 0, fcm_id <- customer.fcm_id ?? "" , created_at <- customer.created_at ?? "", updated_at <- updated_at ?? "" , picture <- customer.picture ?? "", mobile <- customer.mobile ?? "", gender <- customer.gender ?? "", purchase_stickers <- customer.purchaseStickers ?? false,identity <- customer.identity ?? "",directline_room_id <- customer.directline_room_id ?? ""])
            try db.run(insert)
            
        }catch let error{
            
            print("\(#function) error \(error.localizedDescription)")
        }
    }
    func updateCustomerData(customer : Customer) {
        
        do{
            let id = Expression<String>("id")
            let first_name = Expression<String?>("first_name")
            let last_name = Expression<String?>("last_name")
            let email = Expression<String?>("email")
            let device_id = Expression<String?>("device_id")
            let segment_id = Expression<Int?>("segment_id")
            let fcm_id = Expression<String?>("fcm_id")
            let platform = Expression<String?>("platform")
            let badges = Expression<String?>("badges")
            let account_link = Expression<String?>("account_link")
            let status = Expression<String?>("status")
            let updated_at = Expression<String?>("updated_at")
            let created_at = Expression<String?>("created_at")
            let last_visited = Expression<String?>("last_visited")
            let picture = Expression<String?>("picture")
            let xp = Expression<Int?>("xp")
            let coins = Expression<Int?>("coins")
            let mobile = Expression<String?>("mobile")
            let gender = Expression<String?>("gender")
            let purchase_stickers = Expression<Bool?>("purchase_stickers")
            let identity = Expression<String>("identity")
            let directline_room_id = Expression<String?>("directline_room_id")

            let update = CustomerProfile.update(first_name <- customer.first_name , last_name <- customer.last_name, id <- customer._id ?? "" , coins <- customer.coins ,device_id <- customer.device_id , xp <- customer.xp , status <- customer.status, platform <- customer.platform , last_visited <- customer.last_visited , email <- customer.email, segment_id <- customer.segment_id, fcm_id <- customer.fcm_id, created_at <- customer.created_at, updated_at <- updated_at, picture <- customer.picture, mobile <- customer.mobile, gender <- customer.gender,purchase_stickers <- customer.purchaseStickers,identity <- customer.identity!,directline_room_id <- customer.directline_room_id ?? "")
            
            try db.run(update)
            
        }catch let error{
            
           print("\(#function) error \(error.localizedDescription)")
        }
        
        
    }
    func getCustomerData() -> Customer {
        let customer : Customer = Customer.init(dictionary: NSDictionary.init())!
        let id = Expression<String>("id")
        let first_name = Expression<String?>("first_name")
        let last_name = Expression<String?>("last_name")
        let email = Expression<String?>("email")
        let device_id = Expression<String?>("device_id")
        let segment_id = Expression<Int?>("segment_id")
        let fcm_id = Expression<String?>("fcm_id")
        let platform = Expression<String?>("platform")
        let badges = Expression<String?>("badges")
        let account_link = Expression<String?>("account_link")
        let status = Expression<String?>("status")
        let updated_at = Expression<String?>("updated_at")
        let created_at = Expression<String?>("created_at")
        let last_visited = Expression<String?>("last_visited")
        let picture = Expression<String?>("picture")
        let xp = Expression<Int?>("xp")
        let coins = Expression<Int?>("coins")
        let mobile = Expression<String?>("mobile")
        let gender = Expression<String?>("gender")
        let purchase_stickers = Expression<Bool?>("purchase_stickers")
        let identity = Expression<String>("identity")
        let directline_room_id = Expression<String?>("directline_room_id")

        do{
            if self.tableExists(tableName: "CustomerProfile") {
                for customerData in try db.prepare(CustomerProfile) {
                    
                    customer.first_name = customerData[first_name]
                    customer.last_name = customerData[last_name]
                    customer.last_visited = customerData[last_visited]
                    customer._id = customerData[id]
                    customer.email = customerData[email]
                    customer.fcm_id = customerData[fcm_id]
                    customer.segment_id = customerData[segment_id]
                    customer.fcm_id = customerData[fcm_id]
                    customer.status = customerData[status]
                    customer.xp = customerData[xp]
                    customer.purchaseStickers = customerData[purchase_stickers]
                    customer.directline_room_id = customerData[directline_room_id]
                    customer.coins = customerData[coins]
                    customer.picture = customerData[picture]
                    customer.platform = customerData[platform]
                    customer.updated_at = customerData[updated_at]
                    customer.created_at = customerData[created_at]
                    customer.device_id = customerData[device_id]
                    customer.gender = customerData[gender]
                    customer.mobile = customerData[mobile]
                    customer.identity = customerData[identity]
                    CustomerDetails.customerData = customer
                    self.getContentLikesData()
                    self.getContentPurchaseData()
                    self.getHideContents()
                    self.getContentpurchaseLiveIdsData()
                }
            }
        }catch let error{
            print("\(#function) error \(error.localizedDescription)")
            
        }
        return customer
        
    }
    
    func createGiftsTable() {
        
        let id = Expression<String>("id")
        let name = Expression<String?>("name")
        let free_limit = Expression<Int?>("free_limit")
        let coins = Expression<Int?>("coins")
        let photo = Expression<String?>("photo")
        let live_type = Expression<String?>("live_type")
        let xp = Expression<String?>("xp")
        let type = Expression<String?>("type")
        
        
        do{
            try db.run(Gifts.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(free_limit)
                t.column(coins)
                t.column(photo)
                t.column(live_type)
                t.column(xp)
                t.column(type)
            })
            
        }catch{
            
            
            
        }
        
    }
    
    func insertIntoGifts(gift : Gift ) {
        do {
            let id = Expression<String>("id")
            let name = Expression<String?>("name")
            let free_limit = Expression<Int?>("free_limit")
            let coins = Expression<Int?>("coins")
            let photo = Expression<String?>("photo")
            let live_type = Expression<String?>("live_type")
            let xp = Expression<String?>("xp")
            let type = Expression<String?>("type")
            let insert = Gifts.insert(id <- gift.id ?? "", name <- gift.name ?? "" , photo <- gift.spendingPhoto?.thumb ?? "" , coins <- gift.coins ?? 0 ,free_limit <- gift.free_limit ?? 0 , xp <- gift.xp ?? "", type <- gift.type ?? "")
            try db.run(insert)
            
        }catch let error{
            
            print("\(#function) error \(error.localizedDescription)")
        }
        
        
    }
    func getGiftsFromDatabase() -> [Gift]{
        
        var giftArray : [Gift] = [Gift]()
        
        let id = Expression<String>("id")
        let name = Expression<String?>("name")
        let free_limit = Expression<Int?>("free_limit")
        let coins = Expression<Int?>("coins")
        let photo = Expression<String?>("photo")
        let live_type = Expression<String?>("live_type")
        let xp = Expression<String?>("xp")
        let type = Expression<String?>("type")
        
        do{
            if self.tableExists(tableName: "Gifts") {
                
                for giftData in try db.prepare(Gifts) {
                    
                    let dict :  Dictionary<String, Any>? = Dictionary()
                    let gift : Gift = Gift.init(dict: dict)
                    gift.id = giftData[id]
                    gift.name = giftData[name]
                    gift.free_limit = giftData[free_limit]
                    gift.spendingPhoto = SpendingOnPhoto.init(dict:dict )
                    gift.spendingPhoto?.thumb = giftData[photo]
                    gift.photo = Photo.init(dict: dict)
                    gift.photo?.cover = giftData[photo]
                    gift.type = giftData[type]
                    gift.coins = giftData[coins]
                    gift.xp = giftData[xp]
                    gift.live_type = giftData[live_type]
                    giftArray.append(gift)
                }
            }
        }catch let error {
            
            print("\(#function) error \(error.localizedDescription)")
        }
        return giftArray
        
    }
    func createVideoTable() {
        
        let content_id =  Expression<String>("content_id")
        let cover = Expression<String?>("cover")
        let embed_code = Expression<String?>("embed_code")
        let player_type = Expression<String?>("player_type")
        let url = Expression<String?>("url")
        
        do{
            try db.run(Videos.create(ifNotExists: true) { t in
                t.column(content_id, primaryKey: true)
                t.column(cover)
                t.column(player_type)
                t.column(embed_code)
                t.column(url)
            })
            
        }catch let error{
            print("\(#function) error \(error.localizedDescription)")
        }
        
    }
    func insertIntoVideos(video : Video, content_idStr : String) {
        
        let content_id =  Expression<String>("content_id")
        let cover = Expression<String?>("cover")
        let embed_code = Expression<String?>("embed_code")
        let player_type = Expression<String?>("player_type")
        let url = Expression<String?>("url")
        do{
            
            let insert = Videos.insert(content_id <- content_idStr, cover <- video.cover ?? "" , embed_code <- video.embed_code ?? "" , player_type <- video.player_type ?? "" , url <- video.url ?? ""  )
            try db.run(insert)
            
        }catch let error{
            
            print("\(#function) error \(error.localizedDescription)")
        }
        
    }
    
    func getVideoFromDatabase(content_Id : String) -> Video{
        
        let content_id =  Expression<String>("content_id")
        let cover = Expression<String?>("cover")
        let embed_code = Expression<String?>("embed_code")
        let player_type = Expression<String?>("player_type")
        let url = Expression<String?>("url")
        var video : Video!
        do{
            if self.tableExists(tableName: "Videos") {
                for vid in try db.prepare(Videos) {
                    let dict = NSDictionary.init()
                    video = Video(dictionary:dict)!
                    video.cover = vid[cover]
                    video.embed_code = vid[embed_code]
                    video.player_type = vid[player_type]
                    video.url = vid[url]
                    
                }
            }
        }catch let error{
            
             print("\(#function) error \(error.localizedDescription)")
        }
        return video
    }
    
    func createSocialJunctionTable() {
        
//        let id = Expression<String>("id")
        let id = Expression<String>("_id")
        let artist_id = Expression<String?>("artist_id")
        let bucket_id = Expression<String?>("bucket_id")
        let level = Expression<String?>("level")
        let commentbox_enable = Expression<String?>("is_commentbox_enable")
        let caption = Expression<String?>("caption")
        let name = Expression<String?>("name")
        let photo = Expression<String?>("photo")
        let is_album = Expression<String?>("is_album")
        let status = Expression<String?>("status")
        let updated_at = Expression<String?>("updated_at")
        let created_at = Expression<String?>("created_at")
        let date_diff_for_human = Expression<String?>("date_diff_for_human")
        let feeling_activity = Expression<String?>("feeling_activity")
        let published_at = Expression<String?>("published_at")
        //        let poll_stat = Expression<String?>("poll_stat")
        let type = Expression<String?>("type")
        let commercial_type = Expression<String?>("commercial_type")
        let coins = Expression<Int?>("coins")
        let source = Expression<String?>("source")
        let dataType = Expression<String?>("dataType")
        let code = Expression<String?>("code")
        let ordering = Expression<Int?>("ordering")
        let partial_play_duration = Expression<String?>("partial_play_duration")
        let Duration = Expression<String?>("Duration")
        let ageResrtiction = Expression<Int?>("age_restriction")
        let is_expired = Expression<String?>("is_expired")
        let total_votes = Expression<Int?>("total_votes")
        let expired_at = Expression<String?>("expired_at")
        
        do{
            try db.run(SocialJunction.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(artist_id)
                t.column(bucket_id)
                t.column(Duration)
                t.column(level)
                t.column(caption)
                t.column(name)
                t.column(code)
                t.column(ordering)
                t.column(partial_play_duration)
                //                t.column(commentbox_enable)
                t.column(photo)
                t.column(is_album)
                t.column(status)
                t.column(created_at)
                t.column(updated_at)
                t.column(date_diff_for_human)
                t.column(feeling_activity)
                t.column(published_at)
                t.column(type)
                t.column(commercial_type)
                t.column(coins)
                t.column(source)
                t.column(dataType)
                t.column(ageResrtiction)
                t.column(is_expired)
                t.column(total_votes)
                t.column(expired_at)
                //                t.foreignKey(video, references: Videos, id)
            })
            
        }catch let error{
            
            print("\(#function) error \(error.localizedDescription)")
            
        }
        
    }
    
    func insertIntoSocialTable(list : List, datatype : String) {
        
        do {
            let Duration = Expression<String?>("Duration")
            let code = Expression<String?>("code")
            let ordering = Expression<Int?>("ordering")
//            let id = Expression<String>("id")
             let id = Expression<String>("_id")
            let artist_id = Expression<String?>("artist_id")
            let bucket_id = Expression<String?>("bucket_id")
            let level = Expression<Int?>("level")
            let caption = Expression<String?>("caption")
            let name = Expression<String?>("name")
            let commentbox_enable = Expression<String?>("is_commentbox_enable")
            let photo = Expression<String?>("photo")
            let is_album = Expression<String?>("is_album")
            let status = Expression<String?>("status")
            let updated_at = Expression<String?>("updated_at")
            let created_at = Expression<String?>("created_at")
            let date_diff_for_human = Expression<String?>("date_diff_for_human")
            let feeling_activity = Expression<String?>("feeling_activity")
            let published_at = Expression<String?>("published_at")
            //        let poll_stat = Expression<String?>("poll_stat")
            let type = Expression<String?>("type")
            let commercial_type = Expression<String?>("commercial_type")
            let coins = Expression<Int?>("coins")
            let source = Expression<String?>("source")
            let dataType = Expression<String?>("dataType")
            let partial_play_duration = Expression<String?>("partial_play_duration")
            //
            let content_id =  Expression<String>("content_id")
            let cover = Expression<String?>("cover")
            let embed_code = Expression<String?>("embed_code")
            let player_type = Expression<String?>("player_type")
            let url = Expression<String?>("url")
            //
            let likes = Expression<Int?>("likes")
            let comments = Expression<Int?>("comments")
            let shares = Expression<Int?>("shares")
            
            let ageResrtiction = Expression<Int?>("age_restriction")
            let is_expired = Expression<String?>("is_expired")
            let total_votes = Expression<Int?>("total_votes")
            let expired_at = Expression<String?>("expired_at")
            /////
            do{
                let insert = SocialJunction.insert(id <- list._id ?? "", artist_id<-list.artist_id ?? "" , bucket_id <- list.bucket_id ?? "", level <- list.level ?? 0, caption<-list.caption ?? "", name<-list.name ?? "", photo<-list.photo?.cover ?? "" , is_album <- list.is_album ?? "false", status <- list.status ?? "", updated_at <- list.updated_at ?? "", created_at <- list.created_at ?? "", date_diff_for_human<-list.date_diff_for_human ?? "" , feeling_activity <- list.feeling_activity ?? "" , published_at <- list.published_at ?? "" , type <- list.type ?? "", commercial_type <- list.commercial_type ?? "", coins <- list.coins ?? 0, source <- list.source ?? "", dataType <- datatype,code <- list.code ?? "",ordering <- list.ordering ?? 0,partial_play_duration <- list.partial_play_duration,Duration <- list.Duration,ageResrtiction <- list.age_restriction ?? 0,is_expired <- list.is_expired ?? "", total_votes <- list.total_votes ?? 0,expired_at <- list.expired_at ?? "")
                
            
                try db.run(insert)
            }catch let error{
                
                print("\(#function) error1 \(error.localizedDescription)")
            }
            do{
//                let insertStat = Stat.insert(or: OnConflict.replace , [id <- list._id ?? "", likes <- list.stats?.likes ?? 0 , comments <- list.stats?.comments ?? 0, shares <- list.stats?.shares ?? 0 ])
//                try db.run(insertStat)
                if let stat = list.stats , let contentId = list._id {
                    insertIntoStats(stat: stat, contentId: contentId)
                }
                
            }catch let error{
               print("\(#function) error2 \(error.localizedDescription)")
            }
            do{
                let insertVideo = Videos.insert(content_id <- list._id ?? "", cover <- list.video?.cover ?? "" , embed_code <- list.video?.embed_code ?? "", player_type <- list.video?.player_type ?? "" , url <- list.video?.url ?? "")
                
                try db.run(insertVideo)
            }catch let error{
                print("\(#function) error3 \(error.localizedDescription)")
            }
            
            if list.pollStat != nil {
                if let pollStats = list.pollStat {
                    if pollStats.count != 0 {
                        self.insertIntoPoll(polls: pollStats, content_idStr:list._id ?? "")
                    }
                }
            }
            
        }catch let error{
            print("\(#function) error4 \(error.localizedDescription)")
        }
        
    }
    
    func getSocialJunctionFromDatabase(datatype : String )-> [List]{
        
        var socialArray : [List] = [List]()
        
        if (self.db != nil) {
            let Duration = Expression<String?>("Duration")
            let partial_play_duration = Expression<String?>("partial_play_duration")
            let code = Expression<String?>("code")
            let ordering = Expression<Int?>("ordering")
//            let id = Expression<String>("id")
            let id = Expression<String>("_id")
            let artist_id = Expression<String?>("artist_id")
            let bucket_id = Expression<String?>("bucket_id")
            let level = Expression<Int?>("level")
            let caption = Expression<String?>("caption")
            let name = Expression<String?>("name")
            let commentbox_enable = Expression<String?>("is_commentbox_enable")
            let photo = Expression<String?>("photo")
            let is_album = Expression<String?>("is_album")
            let status = Expression<String?>("status")
            let updated_at = Expression<String?>("updated_at")
            let created_at = Expression<String?>("created_at")
            let date_diff_for_human = Expression<String?>("date_diff_for_human")
            let feeling_activity = Expression<String?>("feeling_activity")
            let published_at = Expression<String?>("published_at")
            //        let poll_stat = Expression<String?>("poll_stat")
            let type = Expression<String?>("type")
            let commercial_type = Expression<String?>("commercial_type")
            let coins = Expression<Int?>("coins")
            let source = Expression<String?>("source")
            let dataType = Expression<String?>("dataType")
            
            
            //
            let likes = Expression<Int?>("likes")
            let comments = Expression<Int?>("comments")
            let shares = Expression<Int?>("shares")
            /////
            
            
            let content_id =  Expression<String>("content_id")
            let cover = Expression<String?>("cover")
            let embed_code = Expression<String?>("embed_code")
            let player_type = Expression<String?>("player_type")
            let url = Expression<String?>("url")
            
            let ageResrtiction = Expression<Int?>("age_restriction")
            let is_expired = Expression<String?>("is_expired")
            let total_votes = Expression<Int?>("total_votes")
            let expired_at = Expression<String?>("expired_at")
            
            ////
            
            do{
                if self.tableExists(tableName: "SocialJunction") {
                    let querySocial = SocialJunction.filter(dataType == datatype)
                    
                    for bucket in try db.prepare(querySocial) {
                        let dict = NSDictionary.init()
                        let list : List = List(dictionary:dict)!
                        list._id = bucket[id]
                        //                        list.commentbox_enable = bucket[commentbox_enable]
                        list.name = bucket[name]
                        list.artist_id = bucket[artist_id]
                        list.Duration = bucket[Duration]
                        list.caption = bucket[caption]
                        list.level = bucket[level]
                        list.code = bucket[code]
                        list.ordering = bucket[ordering]
                        list.type = bucket[type]
                        list.partial_play_duration = bucket[partial_play_duration]
                        list.updated_at = bucket[updated_at]
                        list.created_at = bucket[created_at]
                        list.bucket_id = bucket[bucket_id]
                        let dictinary = Dictionary<String, Any>.init()
                        let photoObj : Photo = Photo.init(dict: dictinary)
                        photoObj.cover = bucket[photo]
                        list.photo = photoObj
                        list.is_album = bucket[is_album]
                        list.status = bucket[status]
                        list.date_diff_for_human = bucket[date_diff_for_human]
                        list.feeling_activity = bucket[feeling_activity]
                        list.published_at = bucket[published_at]
                        list.commercial_type = bucket[commercial_type]
                        
                        list.coins = bucket[coins]
                        list.source = bucket[source]
                        list.age_restriction = bucket[ageResrtiction]
                        
                        list.is_expired = bucket[is_expired]
                        list.total_votes = bucket[total_votes]
                        list.expired_at = bucket[expired_at]
                        
                        let query = Stat.filter(id == list._id ?? "")
                        for stat in try db.prepare(query) {
                            print("id: \(stat[id])")
                            
                            let statistics : Stats = Stats.init(dictionary: dictinary as NSDictionary)!
                            statistics.likes = stat[likes]
                            statistics.comments = stat[comments]
                            statistics.shares = stat[shares]
                            list.stats = statistics
                        }
                        let queryVideo = Videos.filter(content_id == list._id ?? "")
                        
                        for vid in try db.prepare(queryVideo) {
                            let dict = NSDictionary.init()
                            if let video : Video = Video(dictionary:dict) {
                                video.cover = vid[cover]
                                video.embed_code = vid[embed_code]
                                video.player_type = vid[player_type]
                                video.url = vid[url]
                                list.video = video
                            }
                        }
                        if (!GlobalFunctions.checkContentBlockId(id: list._id ?? "" )) {
                            socialArray.append(list)
                        }
                        
                        var pollStat = [PollDetail]()
                        pollStat = self.getPollData(content_Id: list._id ?? "")
                        
                        if pollStat.count != 0 {
                            list.pollStat = pollStat
                        }
                        //  }
                    }
                }
                
                
            }catch let error {
                print("\(#function) failed to get error \(error.localizedDescription)")
            }
        }
        return socialArray
        
        
    }
    
    func createStatsTable() {
        let id =  Expression<String>("id")
        let likes = Expression<Int?>("likes")
        let comments = Expression<Int?>("comments")
        let shares = Expression<Int?>("shares")
        do{
            try db.run(Stat.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(likes)
                t.column(comments)
                t.column(shares)
                
            })
            
        }catch let error {
            print("\(#function) error \(error.localizedDescription)")
        }
        
    }
    
    func createBucketListTable() {
        
        let id = Expression<String>("id")
        let artist_id = Expression<String?>("artist_id")
        let level = Expression<Int?>("level")
        let code = Expression<String?>("code")
        let ordring = Expression<Int?>("ordering")
        let caption = Expression<String?>("caption")
        let name = Expression<String?>("name")
        let status = Expression<String?>("status")
        let slug = Expression<String?>("slug")
        let type = Expression<String?>("type")
        let updated_at = Expression<String?>("updated_at")
        let created_at = Expression<String?>("created_at")
        
        do{
            try db.run(Bucket.create(ifNotExists: true) { t in
                
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(artist_id)
                t.column(level)
                t.column(code)
                t.column(ordring)
                t.column(caption)
                t.column(status)
                t.column(updated_at)
                t.column(created_at)
                t.column(slug)
                t.column(type)
            })
            
        } catch let error {
            print("\(#function) error \(error.localizedDescription)")
        }
    }
    
    func addBucketColum()
    {
        do {
            try db.run(Bucket.addColumn(Expression<String?>("photo")))
               print("Added photo")
           } catch {
               print(error)
           }
    }
    
    func getBucketListing(isForStory: Bool = false) -> [List] {
        
        var listArray: [List] = [List]()
        
        if self.db != nil {
            
            let id = Expression<String>("id")
            let artist_id = Expression<String?>("artist_id")
            let level = Expression<Int?>("level")
            let code = Expression<String?>("code")
            let ordering = Expression<Int?>("ordering")
            let caption = Expression<String?>("caption")
            let name = Expression<String?>("name")
            let status = Expression<String?>("status")
            let slug = Expression<String?>("slug")
            let type = Expression<String?>("type")
            let updated_at = Expression<String?>("updated_at")
            let created_at = Expression<String?>("created_at")
            let photo = Expression<String?>("photo")  //rupali
            do {
                if self.tableExists(tableName: "Buckets") {
                    
                    for bucket in try db.prepare(Bucket) {
                        let dict = NSDictionary.init()
                        if let list: List = List(dictionary:dict) {
                            list._id = bucket[id]
                            list.name = bucket[name]
                            list.code = bucket[code]
                            list.ordering = bucket[ordering]
                            list.artist_id = bucket[artist_id]
                            list.caption = bucket[caption]
                            list.level = bucket[level]
                            list.type = bucket[type]
                            list.slug = bucket[slug]
                            list.status = bucket[status]
                            list.updated_at = bucket[updated_at]
                            list.created_at = bucket[created_at]
                            list.photo = Photo.init(dict: dict as? [String : Any])
                            list.photo?.cover = bucket[photo] //rupali
                            listArray.append(list)
                        }
                    }
                }
            } catch let error {
                print("\(#function) error \(error.localizedDescription)")
            }
        }
        
        if isForStory {
            return listArray
        }
                
        return listArray.filter { $0.code != "story" }
    }
    
    func insertIntoStats(stat : Stats , contentId : String) {
        
        let id =  Expression<String>("id")
        let likes = Expression<Int?>("likes")
        let comments = Expression<Int?>("comments")
        let shares = Expression<Int?>("shares")
        do{
            let inserrtStats = Stat.insert(id <- contentId , likes <- stat.likes ?? 0 , comments <- stat.comments ?? 0, shares <- stat.shares ?? 0)
            try db.run(inserrtStats)
        }catch let error{
            
              print("\(#function) error \(error.localizedDescription)")
        }
    }
    
    func insertIntoBucketListTable(list: List ) {
        
        do {
            let id = Expression<String>("id")
            let artist_id = Expression<String?>("artist_id")
            let level = Expression<Int?>("level")
            let code = Expression<String?>("code")
            let ordering = Expression<Int?>("ordering")
            let caption = Expression<String?>("caption")
            let name = Expression<String?>("name")
            let status = Expression<String?>("status")
            let slug = Expression<String?>("slug")
            let type = Expression<String?>("type")
            let updated_at = Expression<String?>("updated_at")
            let created_at = Expression<String?>("created_at")
            let photo = Expression<String?>("photo") //rupali
            //            let stats_id = Expression<String?>("stats_id")

            let insert = Bucket.insert(id <- list._id ?? "" , name <- list.name ?? "" , artist_id <- list.artist_id ?? "" , code <- list.code ?? ""  ,caption <- list.caption  ?? "", level <- list.level ?? 0 , status <- list.status ?? "", slug <- list.slug ?? "", type <- list.type ?? "", updated_at <- list.updated_at ?? "" , created_at <- list.created_at ?? "",ordering <- list.ordering ?? 0, photo <- (list.photo?.cover ?? ""))
            
            try db.run(insert)
            
        }catch let error{
            
            print("\(#function) error \(error.localizedDescription)")
        }
        
        
        
    }
    
    //MARK:- Poll
    func createPollTable() {
        let id = Expression<String>("id")
        let votes = Expression<Int?>("votes")
        let label = Expression<String?>("label")
        let votes_in_percentage = Expression<Double?>("votes_in_percentage")
        let contentId = Expression<String>("content_id")
        let isSelected = Expression<Bool>("isSelected")
        
        do{
            try db.run(Poll.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(votes)
                t.column(label)
                t.column(votes_in_percentage)
                t.column(contentId)
                t.column(isSelected)
            })
            
        }catch{
        }
        
    }
    func insertIntoPoll(polls : [PollDetail], content_idStr : String) {
        
        let contentId =  Expression<String>("content_id")
        let id = Expression<String?>("id")
        let label = Expression<String?>("label")
        let votes_in_percentage = Expression<Double?>("votes_in_percentage")
        let votes = Expression<Int?>("votes")
        let isSelected = Expression<Bool>("isSelected")
        
        for poll in polls {
            do {
                let insert = Poll.insert(contentId <- content_idStr , id <- poll.id ?? "" ,label <- poll.label ?? "",votes_in_percentage <- poll.votes_in_percentage ?? 0 ,votes <- poll.votes ?? 0,isSelected <- poll.isSelected)
                try db.run(insert)
            } catch let error{
                print("\(#function) error \(error.localizedDescription)")
                //                let idStr = self.getIfUserSelecteForContent(userId: CustomerDetails.custId, contentId: content_idStr)
                //                if idStr.count == 1 {
                //                    if poll.id == idStr.first! {
                //                        poll.isSelected = true
                //                    }
                //                }
                //                self.updatePollNewContent(pollId: poll.id ?? "", pollDetail: poll)
            }
        }
    }
    func getPollData(content_Id:String) -> [PollDetail] {
        let contentId =  Expression<String>("content_id")
        let id = Expression<String?>("id")
        let label = Expression<String?>("label")
        let votes_in_percentage = Expression<Double?>("votes_in_percentage")
        let votes = Expression<Int?>("votes")
        let isSelected = Expression<Bool>("isSelected")
        var pollArr = [PollDetail]()
        do{
            if self.tableExists(tableName: "Poll") {
                let queryPoll = Poll.filter(contentId == content_Id)
                for poll in try db.prepare(queryPoll) {
                    let dict = [String: Any]()
                    let pollDe : PollDetail = PollDetail(dictionary:dict)!
                    pollDe.id = poll[id]
                    pollDe.label = poll[label]
                    pollDe.votes_in_percentage = poll[votes_in_percentage]
                    pollDe.votes = poll[votes]
                    pollDe.isSelected = poll[isSelected]
                    pollArr.append(pollDe)
                }
            }
        }catch let e {
            print("\(#function) error \(e.localizedDescription)")
        }
        return pollArr
    }
    func updatePollDetails(contentId:String,pollDeArr:[PollDetail]) {
        let id = Expression<String?>("id")
        let votes_in_percentage = Expression<Double?>("votes_in_percentage")
        let votes = Expression<Int?>("votes")
        let isSelected = Expression<Bool>("isSelected")
        
        //        do{
        if self.tableExists(tableName: "Poll") {
            //                let queryPoll = Poll.filter(contentId == contentId)
            //                for poll in try db.prepare(queryPoll) {
            for newPoll in pollDeArr {
                let pollId = Poll.filter(id == newPoll.id!)
                do {
                    let updatePoll = pollId.update(votes_in_percentage <- newPoll.votes_in_percentage ?? 0 , votes <- newPoll.votes ?? 0 ,isSelected <- newPoll.isSelected)
                    try db.run(updatePoll)
                    print("\(#function) update successfully poll")
                }catch let e {
                    print("\(#function) error \(e.localizedDescription)")
                }
            }
            //                }
        }
        //        }catch let e {
        //            print("\(#function) error \(e.localizedDescription)")
        //        }
    }
    
    func updatePollNewContent(pollId:String,pollDetail:PollDetail) {
        //        let contentId =  Expression<String>("content_id")
        let id = Expression<String?>("id")
        //        let label = Expression<String?>("label")
        let votes_in_percentage = Expression<Double?>("votes_in_percentage")
        let votes = Expression<Int?>("votes")
        let isSelected = Expression<Bool>("isSelected")
        if self.tableExists(tableName: "Poll") {
            let pollId = Poll.filter(id == pollId)
            do {
                let updatePoll = pollId.update(votes_in_percentage <- pollDetail.votes_in_percentage ?? 0 , votes <- pollDetail.votes ?? 0 ,isSelected <- pollDetail.isSelected)
                try db.run(updatePoll)
            }catch let e {
                print("\(#function) error \(e.localizedDescription)")
            }
        }
    }
    func createSelectedPollTable() {
        let id = Expression<String>("id")
        let userId = Expression<String>("userId")
        let contentID = Expression<String>("contentId")
        
        do{
            try db.run(selectedPoll.create(ifNotExists: true) { t in
                //                t.column(id, primaryKey: true)
                t.column(id)
                t.column(userId)
                t.column(contentID)
            })
            
        }catch{
            
        }
    }
    
    func insertIntoContentLikesTable(pollId:String,userID:String,contentId : String) {
        let id = Expression<String>("id")
        let userId = Expression<String>("userId")
        let contentID = Expression<String>("contentId")
        
        do{
            let insert = selectedPoll.insert(id <- pollId , userId <- userID,contentID <- contentId)
            try db.run(insert)
            
        }catch let error{
            
            print("\(#function) error \(error.localizedDescription)")
        }
        
    }
    func getIfUserSelectForPollContent(userId:String,contentId:String) -> [String]{
        let userId = Expression<String>("userId")
        let contentID = Expression<String>("contentId")
        var contentIds = [String]()
        do{
            if self.tableExists(tableName: "SelectedPoll") {
                let queryPoll = selectedPoll.filter(userId == userId)
                
                for poll in try db.prepare(queryPoll) {
                    contentIds.append(poll[contentID])
                    
                }
            }
        }catch let e {
            print("\(#function) error \(e.localizedDescription)")
        }
        return contentIds
    }
    func deletePollData() {
        do{
            if try db.scalar(Poll.exists) {
                try db.run(Poll.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    
    func deleteSelectedPollTable() {
        do{
            if try db.scalar(selectedPoll.exists) {
                try db.run(selectedPoll.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    //MARK:- LIVE
    func createContentspurchaseLiveidsTable() {
        let id = Expression<String>("id")
        do{
            try db.run(ContentPurchaseLive.create(ifNotExists: true) { t in
                t.column(id, primaryKey: false)
            })
            
        }catch{
            
            print("table not created")
        }
    }
    func insertIntoContentPurchaseLiveIdsTable(purchaseId : String) {
        let id = Expression<String>("id")
        
        do{
            let insert = ContentPurchaseLive.insert(id <- purchaseId)
            
            try db.run(insert)
            
        }catch{
            
            print("problem in insertion")
        }
        
    }
    func getContentpurchaseLiveIdsData() {
        
        let id = Expression<String>("id")
        do{
            var likesIds = [String]()
            if self.tableExists(tableName: "ContentPurchaseLive") {
                for likes in try db.prepare(ContentPurchaseLive) {
                    likesIds.append(likes[id])
                }
                if (likesIds != nil && CustomerDetails.customerData != nil) {
                    CustomerDetails.customerData.purchaseLive_ids = likesIds
                }
            }
        }catch{
            
        }
        
    }
    func deleteContentPurchaseLive() {
        do{
            if try db.scalar(ContentPurchaseLive.exists) {
                try db.run(ContentPurchaseLive.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    
    //MARK: Passbook
    func createPassbookTable(deletePreviousData: Bool = false) {
        let _id = Expression<String>("_id")
        let coins_after_txn = Expression<Int>("coins_after_txn")
        let coins_before_txn = Expression<Int>("coins_before_txn")
        let total_coins = Expression<Int>("total_coins")
        let xp = Expression<Int>("xp")
        let amount = Expression<Int>("amount")
        let coins = Expression<Int>("coins")
        let status = Expression<String>("status")
        let platform_version = Expression<String>("platform_version")
        let txn_type = Expression<String>("txn_type")
        let updated_at = Expression<String>("updated_at")
        let created_at = Expression<String>("created_at")
        let quantity = Expression<Int>("quantity")
        let package_price = Expression<Int>("package_price")
        let platform = Expression<String>("platform")
        let entity_id = Expression<String>("entity_id")
        let entity = Expression<String>("entity")
        let passbook_applied = Expression<Bool>("passbook_applied")
        
        // LEDGER META INFO
        let thumb = Expression<String>("thumb")
        let caption = Expression<String>("caption")
        let type = Expression<String>("type")
        let video = Expression<String>("video")
        let name = Expression<String>("name")
        let audio = Expression<String>("audio")
        let description = Expression<String>("description")
        let vendor_txn_id = Expression<String>("vendor_txn_id")
        let currency_code = Expression<String>("currency_code")
        let transaction_price = Expression<String>("transaction_price")
        let vendor = Expression<String>("vendor")
        
        // ARTIST
        let first_name = Expression<String>("first_name")
        let last_name = Expression<String>("last_name")
        
        do{
            try db.run(PassbookTable.create(ifNotExists: true) { t in
                t.column(_id, primaryKey: true)
                t.column(coins_after_txn)
                t.column(coins_before_txn)
                t.column(total_coins)
                t.column(xp)
                t.column(amount)
                t.column(coins)
                t.column(status)
                t.column(platform_version)
                t.column(txn_type)
                t.column(updated_at)
                t.column(created_at)
                t.column(quantity)
                t.column(package_price)
                t.column(platform)
                t.column(entity_id)
                t.column(entity)
                t.column(passbook_applied)
                
                // LEDGER META INFO
                t.column(thumb)
                t.column(caption)
                t.column(type)
                t.column(video)
                t.column(name)
                t.column(audio)
                t.column(description)
                t.column(vendor_txn_id)
                t.column(currency_code)
                t.column(transaction_price)
                t.column(vendor)
                
                t.column(first_name)
                t.column(last_name)
            })
            
            if deletePreviousData {
                try db.run(PassbookTable.delete())
            }
            
        } catch {
            print("\(#function) DataBase Error: " + error.localizedDescription)
        }
    }
    
    func savePassbookListLocally(transaction : PassbookList, deletePreviousData: Bool)
    {
        createPassbookTable(deletePreviousData: deletePreviousData)
        let _id = Expression<String>("_id")
        let coins_after_txn = Expression<Int>("coins_after_txn")
        let coins_before_txn = Expression<Int>("coins_before_txn")
        let total_coins = Expression<Int>("total_coins")
        let xp = Expression<Int>("xp")
        let amount = Expression<Int>("amount")
        let coins = Expression<Int>("coins")
        let status = Expression<String>("status")
        let platform_version = Expression<String>("platform_version")
        let txn_type = Expression<String>("txn_type")
        let updated_at = Expression<String>("updated_at")
        let created_at = Expression<String>("created_at")
        let quantity = Expression<Int>("quantity")
        let package_price = Expression<Int>("package_price")
        let platform = Expression<String>("platform")
        let entity_id = Expression<String>("entity_id")
        let entity = Expression<String>("entity")
        let passbook_applied = Expression<Bool>("passbook_applied")
        
        let thumb = Expression<String>("thumb")
        let caption = Expression<String>("caption")
        let type = Expression<String>("type")
        let video = Expression<String>("video")
        let name = Expression<String>("name")
        let audio = Expression<String>("audio")
        let description = Expression<String>("description")
        let vendor_txn_id = Expression<String>("vendor_txn_id")
        let currency_code = Expression<String>("currency_code")
        let transaction_price = Expression<String>("transaction_price")
        let vendor = Expression<String>("vendor")
        
        // ARTIST
        let first_name = Expression<String>("first_name")
        let last_name = Expression<String>("last_name")
        do{
            let insert = PassbookTable.insert( _id <- transaction._id ?? "" , coins_after_txn <- transaction.coins_after_txn ?? 0 ,   coins_before_txn <- transaction.coins_before_txn ?? 0 ,  total_coins <- transaction.total_coins ?? 0 ,  xp <- transaction.xp ?? 0 ,  amount <- transaction.amount ?? 0,  coins <- transaction.coins ?? 0,  status <- transaction.status ?? "" , platform_version <- transaction.platform_version ?? "" , txn_type <- transaction.txn_type ?? "" ,updated_at <- transaction.updated_at ?? "", created_at <- transaction.created_at ?? "" , quantity <- transaction.quantity ?? 0, package_price <- transaction.package_price ?? 0, platform <- transaction.platform ?? "", entity_id <- transaction.entity_id ?? "",  entity <- transaction.entity ?? "", passbook_applied <- transaction.passbook_applied ?? false,
                                               
                                               thumb <- transaction.meta_info?.thumb ?? "" , caption <- transaction.meta_info?.caption ?? "" ,
                                               type <- transaction.meta_info?.type ?? "" , video <- transaction.meta_info?.video ?? "" ,
                                               name <- transaction.meta_info?.name ?? "" , audio <- transaction.meta_info?.audio ?? "" ,
                                               description <- transaction.meta_info?.description ?? "" , description <- transaction.meta_info?.description ?? "" ,
                                               vendor_txn_id <- transaction.meta_info?.vendor_txn_id ?? "" , currency_code <- transaction.meta_info?.currency_code ?? "" ,
                                               transaction_price <- transaction.meta_info?.transaction_price ?? "", vendor <- transaction.meta_info?.vendor ?? "",
                                               
                                               first_name <- transaction.artist?.first_name ?? "" , last_name <- transaction.artist?.last_name ?? ""
                
            )
            
            try db.run(insert)
            
        } catch {
            print("\(#function) DataBase Error: " + error.localizedDescription)
        }
    }
    func getLocallySavedPassbookList() -> [PassbookList]? {
        let stringKeys: [String: [String]] = ["passbook": ["_id", "status", "platform_version", "txn_type", "status", "platform_version", "txn_type", "updated_at", "created_at", "platform", "entity_id", "entity"], "metaInfo": ["thumb", "caption", "type", "video", "name", "audio", "description", "vendor_txn_id", "currency_code", "vendor", "transaction_price"], "artist" :["first_name", "last_name"]]
        let passbookIntKeys: [String] = ["coins_after_txn", "coins_before_txn", "total_coins", "xp", "amount", "coins", "quantity", "package_price" ]
        let passbookBoolKeys: [String] = ["passbook_applied"]
        
        var passbookList: [PassbookList] = []
        
        do{
            if self.tableExists(tableName: "Passbook") {
                print("Passbook tableExists")
                let passbookListDB = try db.prepare(PassbookTable)
                for transactionData in passbookListDB {
                    var passbookDictionary: [String: Any] = [:]
                    var metaInfoDictionary: [String: Any] = [:]
                    var artistDictionary: [String: Any] = [:]
                    
                    if let passbookdata = stringKeys["passbook"] {
                        for passbookParameter in passbookdata {
                            passbookDictionary[passbookParameter] = transactionData[Expression<String>(passbookParameter)]
                        }
                    }
                    
                    for passbookParameter in passbookIntKeys {
                        passbookDictionary[passbookParameter] = transactionData[Expression<Int>(passbookParameter)]
                    }
                    
                    for passbookParameter in passbookBoolKeys {
                        passbookDictionary[passbookParameter] = transactionData[Expression<Bool>(passbookParameter)]
                    }
                    
                    if let metaInfo = stringKeys["metaInfo"] {
                        for parameter in metaInfo {
                            metaInfoDictionary[parameter] = transactionData[Expression<String>(parameter)]
                        }
                    }
                    
                    if let artist = stringKeys["artist"] {
                        for parameter in artist {
                            artistDictionary[parameter] = transactionData[Expression<String>(parameter)]
                        }
                    }
                    
                    passbookDictionary["meta_info"] = metaInfoDictionary
                    passbookDictionary["artist"] = artistDictionary
                    
                    if let passbook = PassbookList.initWithDictionary(data: passbookDictionary) {
                        passbookList.append(passbook)
                    }
                }
            }
            return passbookList
        } catch {
            print("\(#function) DataBase Error: " + error.localizedDescription)
            return nil
        }
    }
    // MARK: DELETE TABLE
    
    func deleteAllData() {
        self.deleteCustomerProfile()
        self.deleteGifts()
//        self.deleteBuckets()
        self.deleteContentLikes()
        self.deleteContentPurchase()
        self.deleteHideTable()
        self.deleteCommentsTable()
        self.deleteReplyTable()
        self.deletePurchaseTable()
        self.deleteSpendingTable()
        self.deleteRewardsTable()
        self.deleteFansTable()
        self.deleteSocialJunction()
        self.deleteGifts()
        self.deleteStats()
        self.deleteVideos()
        self.deletePollData()
        self.deleteSelectedPollTable()
        self.deleteContentPurchaseLive()
    }
    
    func deleteSocialJunction() {
        do{
            if try db.scalar(SocialJunction.exists) {
                try db.run(SocialJunction.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    
    func deleteStats() {
        do{
            if try db.scalar(Stat.exists) {
                try db.run(Stat.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    
    func deleteSpendingGift() {
        do{
            if try db.scalar(SpendingGift.exists) {
                try db.run(SpendingGift.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    
    func deleteVideos() {
        do{
            if try db.scalar(Videos.exists) {
                try db.run(Videos.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    
    func deleteBuckets() {
        do{
            if try db.scalar(Bucket.exists) {
                try db.run(Bucket.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    
    func deleteCustomerProfile() {
        do{
            if try db.scalar(CustomerProfile.exists) {
                try db.run(CustomerProfile.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deleteContentLikes() {
        do{
            if try db.scalar(ContentLikes.exists) {
                try db.run(ContentLikes.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deleteContentPurchase() {
        do{
            if try db.scalar(ContentPurchase.exists) {
                try db.run(ContentPurchase.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deleteGifts() {
        do{
            if try db.scalar(Gifts.exists) {
                try db.run(Gifts.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deleteHideTable() {
        do{
            if try db.scalar(HideContent.exists) {
                try db.run(HideContent.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deleteCommentsTable() {
        do{
            if try db.scalar(CommentTable.exists) {
                try db.run(CommentTable.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deleteReplyTable() {
        do{
            if try db.scalar(ReplyTable.exists) {
                try db.run(ReplyTable.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deleteFansTable() {
        do{
            if try db.scalar(FavFans.exists) {
                try db.run(FavFans.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deletePurchaseTable() {
        do{
            if try db.scalar(PurchaseTable.exists) {
                try db.run(PurchaseTable.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deleteSpendingTable() {
        do{
            if try db.scalar(SpendingTable.exists) {
                try db.run(SpendingTable.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
    func deleteRewardsTable() {
        do{
            if try db.scalar(RewardsTable.exists) {
                try db.run(RewardsTable.delete())
            }
        }catch(let error ) {
            print(error.localizedDescription)
            
        }
    }
}
extension DatabaseManager {
    func tableExists(tableName: String) -> Bool {
        var count:Int64 = 0
        do {
            count = try (db.scalar(
                "SELECT EXISTS(SELECT name FROM sqlite_master WHERE name = ?)", tableName
                ) as? Int64)! 
        } catch let e {
            print("\(#function) error error \(e.localizedDescription)")
        }
       //caught error atal error: 'try!' expression unexpectedly raised an error: database is locked (code: 5)
        if count>0{
            return true
        }
        else {
            return false
        }
    }
    
}

