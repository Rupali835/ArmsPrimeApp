//
//  StringConstants.swift
//  Producer
//
//  Created by developer2 on 19/08/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import Foundation

var stringConstants: StringConstants = {
    
    return StringConstants()
}()

class StringConstants: NSObject {
    
    // MARK: - Strings
    let appName = "Ankita Dave"
    let ok = "OK"
    let cancel = "Cancel"
    let done = "Done"
    let yes = "Yes"
    let no = "No"
    let camera = "Camera"
    let library = "Library"
    let add = "Add"

    let email = "Email"
    let password = "Password"
    
    let error = "Error"
    let selectNow = "Select"
    let enterNow = "Enter"
    
    let takePhoto = "Take Photo"
    let startVideoRecord = "Start Video Recording"
    let stopVideoRecord = "Stop Video Recording"
    
    let selectPlatform = "Select Platform"
    let selectAgeRating = "Select Age Rating"
    let selectFanType = "Select Fan Type"
    let selectBucket = "Select Bucket"
    let addLocation = "Add Location"
    let extractingMedia = "Exporting Media..."
    let fetchingPlaceDetails = "Fetching Details..."
    let downloading = "Downloading..."
    let desc = "Description"
    let optional = "optional"
    let typeHere = "Type here.."
    let selectDate = "Select Date"
    let album = "Album"
    let photo = "Photo"
    let video = "Video"
    let audio = "Audio"
    let mediaContent = "Media Content"
    let waitingInQueue = "Waiting in queue.."
    let uploading = "Uploading"
    let nothingToUpload = "No media to upload"
    let tapToUpload = "Tap on '+' button to upload"
    let tapToSchedule = "Tap on 'Schedule Live Now' button to schedule new event"
    let updatingToServer = "Updating to server"
    let noRecordsFound = "No record found"
    let noRequestsFound = "No request found"
    let noRequestCompletedFound = "No request completed yet"
    let noRequestRejectedFound = "No request rejected yet"
    let noCommentsFound = "No comment yet"
    let enterCoin = "Enter coins"
    let insights = "Insights"
    let totalOrders = "Total Orders"
    let revenue = "Revenue"
    let INR = "INR"
    let postedOn = "Posted on"
    let viewEarning = "View Earnings"
    let totalEarning = "Total Earnings"
    let viewReplies = "View replies"
    let comments = "comments"
    let none = "None"
    let bucketName = "Bucket Name"
    let close = "Close"
    let delete = "Delete"
    let share = "Share"
    let edit = "Edit"
    let report = "Report"
    let download = "Download"
    let pinToTop = "Pin to Top"
    let unpinned = "Unpinned"
    let TapToSee = "Tap here to see"
    let hey = "Hey"
    let typeComment = "Type comment here.."
    let noStickersFound = "No Stickers Found"
    let editComment = "Edit Comment"
    let replying = "Replying"
    let to = "to"
    let save = "Save"
    let contentDetails = "Content Details"
    let albumDetails = "Album Details"
    let eg = "eg"
    let filter = "Filter"
    let billingDetails = "Billing Details"
    let guest = "Guest"
    let version = "Version"
    let live = "Live"
    let staging = "Staging"
    let selectEnvironment = "Select Environment"
    let scheduledStartDate = "Scheduled Start Date"
    let scheduledEndDate = "Scheduled End Date"
    let active = "active"
    let inactive = "inactive"
    let confirmation = "Confirmation"
    let update = "UPDATE"
    let retry = "Retry"
    let back = "Back"
    let rejectionType = "Rejection Type"
    let youWillLose = "You will lose"
    let published = "Published"
    let unpublished = "Unpublished"
    let publish = "Publish"
    let unpublish = "Unpublish"
    let success = "Success"
    let forgotPassword = "Forgot Password?"
    let liveStreamingPaused = "Live Streaming Paused"
    let youAreLiveNow = "You are live now"
    let connecting = "Connecting..."
    let block = "Block"
    let shoutouts = "shoutouts"
    let notifications = "notifications"
    let directLine = "Direct Line"
    let forgotoPasswordSubject = "Request To Change The Password"
    let warning = "Warning"
    let celebyte = "Celebytes"
    let saveToLibrary = "Save"
    let typeYourComment = "Type your comment here.."
    let updateSmall = "Update"
    let later = "Later"
    let coins = "coins"
    let coin = "coin"
    let hours = "hours"
    let hour = "hour"
    let minutes = "minutes"
    let minute = "minute"
    let seconds = "seconds"
    let second = "second"
    let strContinue = "continue"
    
    // MARK: - Error Messages

    // MARK: - Screen Titles
    let eventDetails = "EVENT DETAILS"
    let upcomingEvent = "UPCOMING EVENTS"
    let pastEvent = "PAST EVENTS"
    let createLiveEvent = "CREATE LIVE EVENT"
    let updateLiveEvent = "EDIT LIVE EVENT"
    let paidEvent = "PAID LIVE EVENT"
    let home = "HOME"
    let billing = "BILLING"
    let reports = "REPORTS"
    let menu = "MENU"
    let editProfile = "EDIT PROFILE"
    let cancelEvent = "CANCEL EVENT"
    let recordIntroVideo = "RECORD INTRODUCTORY VIDEO"
    let recordShoutoutVideo = "RECORD CELEBYTE VIDEO"
    let recordedIntroVideo = "RECORDED INTRODUCTORY VIDEO"
    let recordedShoutoutVideo = "RECORDED CELEBYTE VIDEO"
    let uploaderQueue = "UPLOADER QUEUE"
    let requestDetails = "REQUEST DETAILS"
    let titleAcceptTnc = "ACCEPT TERMS AND CONDITIONS"
    let errorEmptyTnC = "Please accept terms and conditions."


    // MARK: - Error Messages
    let errorEmptyEmail = "Please enter email id."
    let errorInvalidEmail = "Please enter valid email id."
    let errorEmptyPassword = "Plesse enter password."
    let errorEmptyEventName = "Please enter name."
    let errorEmptyEventDescription = "Please enter description."
    let errorEmptyScheduleStart = "Please schedule start of the event."
    let errorEmptyScheduleEnd = "Please schedule end of the event."
    let errorEmptyLeadCast = "Please enter lead cast."
    let errorEmptyCasts = "Please enter casts."
    let errorEmptyCoins = "Please enter coins."
    let errorEmptyMediaTitle = "Please enter media title."
    let errorEmptyPlatform = "Please select at least one platform."
    let errorEmptyMediaLocation = "Please select media location."
    let errorEmptyMediaPrice = "Please enter media price."
    let errorEmptyAlbumTitle = "Please enter album title."
    let errorEmptyAlbumDesc = "Please enter album description."
    let errorEmptyAlbumPrice = "Please enter album price."
    let errorEmptyNotificationTitle = "Please enter notification title."
    let errorEmptyNotificationDesc = "Please enter notification description."
    let errorEmptyNotificationDate = "Please select notification scheduled date."
    let errorEmptyBucket = "Please select bucket to upload media in it."
    let errorNoPhotoInAlbum = "Please select at least one photo to create album."
    let errorEmptyStartDate = "Please select start date."
    let errorEmptyEndDate = "Please select end date."
    let errorEmptyPrice = "Do you want to continue without adding price to media?"
    let errorEmptyComment = "Please write your comment."
    let errorEmptyNotificationBucket = "Please select bucket."
    let errorMailUnavailable = "Mail services not available."
    let errorMonetizationCantChange = "For any change in content monetization after the content is published is not allowed. Please contact administrator for more details."
    let errorEmptyRejectionType = "Please select rejection type."
    let errorEmptyRejectionReason = "Please enter rejection reason."
    let errorEmptyLiveEventName = "Please enter event name."
    let errorEmptyLiveEventDesc = "Please enter event description."
    let errorEmptyLiveEventStartDate = "Please select event start date."
    let errorEmptyLiveEventEndDate = "Please select event end date."
    let errorEmptyLiveEventCoins = "Please enter event coins."
    let errorEmptyFirstName = "Please enter first name."
    let errorEmptyLastName = "Please enter last name."
    let errorInvalidMobile = "Please enter valid mobile number."
    let errorEmptyPlatforms = "Please select at least one platform."
    let errorInSavingMediaInLibrary = "There might be some problem in saving media in library, Please check your phone's available space or try again later."
    let errorInDownloadedFile = "There might be some problem in downloaded media, Please try again later."
    let errorEmptyCancelReason = "Please enter reason to cancel event."
    let errorNoChange = "Nothing has been changed."
    let errorDownloadURLMissing = "Download url is missing."
    let errorDownloadStatusMissing = "Download status is missing."
    let errorPhotoSize = "Photo must not be greater than 7 MB."
    let errorPhotoIssue = "This photo is having problem, please try another."
    let errorRTMConnectionIssue = "There might be some problem in RTM connection, please try again later."
    
    let selectDurationToSeeAvailableSlots = "Select duration to see available slots"
    let noAvailableSlots = "No slots for selected date & duration"
    let selectDurationToSeeViewCost = "Select duration to see cost"
    let errEmptyRating = "Please give ratings."
    let msgLiveFeedbackSuccess = "Thank you for your feedback."
    let liveAudioPaused = "Audio Paused"
    let liveVideoPaused = "Video Paused"
    let titleRescheduleVideoCall = "RESCHEDULE A VIDEO CALL"
    let titleAvailableDaysTime = "AVAILABLE DAYS & TIME"
    let titleDNDDates = "DND DATES"
       
    
    // MARK: - Alert Messages
    let agoraLiveStop = "Are you sure you want to stop?"
    let noInternet = "You are not connected to internet, Please check your network connection."
    let somethingWentWrong = "Something went wrong, plese try again later."
    let serverProblem = "There might be some problem on server, Please try again later."
    let liveNotConfigured = "You are not configured on server to go live."
    let msgDeleteMedia = "Are you sure you want to delete this media?"
    let msgAlbumPostPublish = "Your post has been saved, You will be notified when your post gets uploaded on your app."
    let msgUploadedToServer = "has been uploaded to your app."
    let msgCreateAlbum = "Do you want to create album?"
    let msgPartialInfo = """
    Partial paid means the creator can keep some photos/ videos under paywall and some free. This can be used when you are uploading multiple photos/ video content and wanted to monetise the specific twist of any movie or photo. Free content will give user the idea about the content
"""
    let msgRevenueNote = "This is only an approximate figures subjected to the T@C by payment gateway. Figures might changed as per the final compilation at the monthly payout settlement. For any further details please contact"
    let msgLogoutComfirmation = "Are you sure you want to logout?"
    let msgSeeUploadContent = "See your uploaded media contents under\n\"My Feed\" section."
    let msgGreeting = "Have a great day ahead!"
    let msgCommentDelete = "Are you sure you want to delete this comment?"
    let msgMediaUpdate = "Content details has been updated successfully."
    let msgLiveNotConfigured = "Live is not configured on server. Please contact support team."
    let msgSalesInfo = "This is an approx gross revenue only. The final amount during payout will change subjected to PG commissions, chargebacks, refunds and other expenses if any*"
    let msgServerUnderMaintenance = "Server is temporarily unavailable or under maintenance. Request you to please try again after sometime."
    let msgIntroVideoCreated = "Your introductory video has been created successfully."
    let msgEmailNotConfiguredInSettings = "Please configure your email address in settings."
    let msgEmptySubject = "Please enter the subject."
    let msgEmptyMessage = "Please enter the message."
    let msgLiveEventCreateSuccess = "Your live event has been created successfully."
    let msgLiveEventUpdateSuccess = "Your live event has been updated successfully."
    let msgLiveEventCancelSuccess = "Your live event has been cancelled."
    let msgDeleteEventConfirmation = "Are you sure you want to this event?"
    let msgProblemInStartingLive = "Failed to connect live streaming."
    let msgMediaSavedInPhotoLibrary = "Your media has been saved to photo library."
    let msgAgoraJoiningProblem = "There might be some problem in going live at the moment, Please try again later."
    let msgUploadDeleteConfirmation = "Are you sure you want to delete this media?"
    let msgDiscardRecordedVideo = "Are you sure you want to discard recorded video and go back?"
    let msgCelebyteVideoUploadedSuccess = "Your celebyte video has been submitted successfully."
    let msgIntroVideoUploadedSuccess = "Your introductory video has been posted successfully."
    let msgHelpSupportSuccess = "Your query has been submitted successfully, Support team will solve it soon."
    let msgForgotPasswordBody = """
    Hi Admin,

    I am unable to login to my account. Could you please help me to reset it?

    Thanks
    """
    let msgVideoUploaded = "Your video has been uploaded successfully."
    let msgNotificationSentSuccess = "Your message has been broadcasted successfully."
    let msgDownloadMediaTranscoding = "Your media is being transcoded on server, Please try again after some time."
    let msgForceUpdate = "New version is available on AppStore, please update your application."
    let msgCallRequestSent = "Your call request has been sent successfully."
    let msgCallRequestFailed = "Problem in sending call request, try again later."
    let msgCallRequestInQueue = "Your call request is in queue."
    let msgCutCall = "You are in live video call, are you sure you want to cancel it and go back?"
    let msgCoinsWillBeDeducted = "will be deducted from your wallet only if your request is accepted."
    
    let titleVideoCall = "My Requests"
    let titleVideoMessage = "Video Message"
    let titleAcceptedVideoRequest = "Request accepted. Please be available as per scheduled time slot."
       
       // MARK: - Video call and DL Popup
       let titleInsufficientBalance = "You don't have enough coins in your wallet. Please recharge to continue."
       let titleDLMessageUnlock = "To view this content"
    //New copies
         let enterEmail = "Enter your email address"
         let enterPhone = "Enter your phone number"
         let errEmptyPhoneNumber = "Please enter your phone number."
         let errValidPhoneNumber = "Please enter valid phone number."
         let errInvalidPhoneNumber = "Please enter valid phone number."
         let errEmptyEmailAddress = "Please enter your email address."
         let errInvalidEmailAddress = "Please enter valid email address."
         let errServerProblem = "There might be some problem on server, Please try again later."
         let errSomethingWentWrong = "Something went wrong, plese try again later."
         let msgVerifyDesc = "Please enter the verification code that has been sent to"
         let errNoInternet = "You are not connected to internet, Please check your network connection."
         let titleSelectCountry = "SELECT COUNTRY"
         let errEnterOTP = "Please enter OTP."
         let titleVerifyOTP = "VERIFY OTP"
         let titleOneTypePwd = "OTP VERIFICATION"
         let titleVerifyPhone = "OTP VERIFICATION"
         let titleVerifyEmail = "OTP VERIFICATION"
         let resend = "Resend"
         let termsCondition = "Terms & Conditions"
         let privacyPolicy = "Privacy Policy"
         let loginTerms = "By signing in, you agree to the Terms & Conditions and Privacy Policy"
         
         let profile = "Update profile picture and earn free coins"
         let firsName = "Add your first name and earn free coins"
         let lastName = "Add your last name and earn free coins"
         let emailMessage = "Verify your email and earn free coins"
         let mobileNumber = "Verify your phone number and earn free coins"
         let dateOfBirth = "Add your date of birth and earn free coins"
         let gender = "Add your gender and earn free coins"
         let mobileValidatemessage = "The mobile may not be greater than 10 characters."
         
         
         let firstNameMessage = "First name should contain at least 3 characters"
         let lastNameMessage = "Last name should contain at least 3 characters"
         let emailIdMessage = "Email you entered is invalid"
         let mobileNumberMessage = "Mobile number you entered is invalid"
         let dobMessage = "Date of Birth not added"
         let genderMessage = "Gender not added"
     }
     enum CoachMarkText: String {

         
         case coinPurchase
         

         var text: String {
             switch self {
             
             case .coinPurchase:
                 return "Complete your profile and get free coins"
            
             }
         }

     }

// MARK: - Dynamic String Constants
extension StringConstants {
    
    // Messages
    func msgCallDuration(_ duration: String) -> String {
    
        let msg = "This will be \(duration) video call, can be disconnected if found any misbehaviour during call."
        return msg
    }
}
