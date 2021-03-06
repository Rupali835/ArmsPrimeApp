![Logo](https://user-images.githubusercontent.com/15011722/32040752-7237c3c2-ba4f-11e7-9d68-a019049fccf5.png)
# MORichNotification

[![Version](https://img.shields.io/cocoapods/v/MORichNotification.svg?style=flat)](http://cocoapods.org/pods/MORichNotification)
[![License](https://img.shields.io/cocoapods/l/MORichNotification.svg?style=flat)](http://cocoapods.org/pods/MORichNotification)

Notifications have got a complete revamp in iOS10 with introduction of new UserNotifications and UserNotificationsUI framework. Now Apple has given us the ability to add images, gifs, audio and video files to the notifications. MORichNotification contains the part of MoEngageSDK where it handles these Rich Notifications.


* First, create a Notification Service Extension for your app.

* Then integrate MORichNotification to Notification Service Extension via CocoaPods. Add the following line to your podfile for the Notification Service extension target. 

  ```pod 'MORichNotification'```

  To update, simply run ```pod update```

  For more information on integration of the SDK, follow this [link](https://docs.moengage.com/docs/push-notification-implementation#notification-service-extension-target-implementation).

* Make the following code changes to your NotificationService Extension files:
  #### Objective-C:
  
```
#import "NotificationService.h"
#import <MORichNotification/MORichNotification.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    @try {
        //TODO: Add your App Group ID
        [MORichNotification setAppGroupID:@"Your App Group ID"];
        
        self.contentHandler = contentHandler;
        self.bestAttemptContent = [request.content mutableCopy];
        
        //Handle Rich Notification
        [MORichNotification handleRichNotificationRequest:request withContentHandler:contentHandler];
    } @catch (NSException *exception) {
        NSLog(@"MoEngage : exception : %@",exception);
    }
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
```
  
  #### Swift:
  ```
import UserNotifications
import MORichNotification

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        //TODO: Add your App Group ID
        MORichNotification.setAppGroupID("Your App Group ID")
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        //Handle Rich Notification
        MORichNotification.handle(request, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
```

**NOTE** : 
1. You can use MORichNotifications only if you are using [MoEngage-iOS-SDK](https://github.com/moengage/MoEngage-iOS-SDK) in your app, as it will process only the notifications sent via MoEngage.
2. Http URL's aren't supported in iOS10 unless explicitly specified in the plist. You will have include App Transport Security Settings Dictionary in your Notification Service Extension's Info.plist and inside this set Allow Arbitrary Loads to YES.
3. Refer to the following [link](https://developer.apple.com/documentation/usernotifications/unnotificationattachment#overview) to know about the size and format limitation for attachments(media) supported in Rich Notifications.


## Developer Docs
Please refer to our developer docs to know more about MORichNotification: https://docs.moengage.com/docs/push-notification-implementation#notification-service-extension-target-implementation.

## Change Log
See [SDK Change Log](https://github.com/moengage/MORichNotification/blob/master/CHANGELOG.md) for information on every released version.

