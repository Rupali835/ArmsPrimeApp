//
//  MOUtils.h
//  MOUtils
//
//  Created by Chengappa C D on 30/10/19.
//  Copyright © 2019 MoEngage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOCoreUtils : NSObject

#pragma mark- SDK Storage Methods
+(NSString*)getSDKLibraryDirectoryPath;
+(NSString*)getDocumentsDirectoryPath;


#pragma mark- Top ViewController Methods
+(UIViewController*)getTopMostViewController;
+(UIViewController*)getTopMostPresentedViewController;

#pragma mark- UI Utils Methods
+(CGFloat)deviceScreenWidth;
+(CGFloat)deviceScreenHeight;

#pragma mark- Common Actions Methods
+(void)showAlertViewWithMessage:(NSString *)message andTitle:(NSString*)title;
+(void)openDeeplink:(NSURL*)link;
+(void)openRichLandingLink:(NSURL*)link;

#pragma mark- Encryption Methods
+(NSString *)MD5hashForString:(NSString*)str;

#pragma mark- AppDelegate Proxy Utils
+ (BOOL)isAppDelegateProxyEnabled;
+ (NSString*)getAppDelegateProxyInfoPlistKey;

#pragma mark- Misc Methods

//App ID
+(void)saveAppId:(NSString*)appId;
+(NSString*)getMoEngageAppId;

//SDK Version
+(NSString*)getMoEngageSDKVersion;

//App Info
+(NSString*)appVersion;
+(NSString*)bundleIdentifier;

// Unique ID
+(NSString*)getSDKUniqueIdForUser;
+(NSString*)saveUniqueIdentifierForUser;

// Device Details
+(NSString*)getIDFV;
+(NSString*)getDeviceName;
+(NSString*)getDeviceModel;
+(NSString*)getDeviceSystemVersion;
+(NSString*)getDeviceLocalizedModel;


//Push Token
+(void)saveDeviceToken:(NSString*)dToken;
+(NSString*)getDeviceToken;


// Misc
+(NSString*)getJSONStringFromDictionary:(NSDictionary*)dict;
+(void)registerInstall;
+(BOOL)installRegistered;


+(NSString*)hexTokenForData:(NSData*)data;
+(NSMutableDictionary*)transformPayloadForIncompatibleTypes:(NSMutableDictionary*)payload;

+(NSString*)getDeviceUniqueID;
@end

NS_ASSUME_NONNULL_END


