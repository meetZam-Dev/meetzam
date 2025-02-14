//
//  AWSMobileClient.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.10
//
//
import Foundation
import UIKit
import AWSCore
import AWSMobileHubHelper

/**
 * AWSMobileClient is a singleton that bootstraps the app. It creates an identity manager to establish the user identity with Amazon Cognito.
 */
class AWSMobileClient: NSObject {
    
    // Shared instance of this class
    static let sharedInstance = AWSMobileClient()
    fileprivate var isInitialized: Bool
    //Used for checking whether Push Notification is enabled in Amazon Pinpoint
    static let remoteNotificationKey = "RemoteNotification"
    fileprivate override init() {
        isInitialized = false
        super.init()
    }
    
    deinit {
        // Should never be called
        print("Mobile Client deinitialized. This should not happen.")
    }
    
    /**
     * Configure third-party services from application delegate with url, application
     * that called this provider, and any annotation info.
     *
     * - parameter application: instance from application delegate.
     * - parameter url: called from application delegate.
     * - parameter sourceApplication: that triggered this call.
     * - parameter annotation: from application delegate.
     * - returns: true if call was handled by this component
     */
    func withApplication(_ application: UIApplication, withURL url: URL, withSourceApplication sourceApplication: String?, withAnnotation annotation: Any) -> Bool {
        print("withApplication:withURL")
        AWSIdentityManager.default().interceptApplication(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        if (!isInitialized) {
            isInitialized = true
        }
        
        return false;
    }
    
    /**
     * Performs any additional activation steps required of the third party services
     * e.g. Facebook
     *
     * - parameter application: from application delegate.
     */
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive:")
    }
    
    
    /**
    * Handles callback from iOS platform indicating push notification registration was a success.
    * - parameter application: application
    * - parameter deviceToken: device token
    */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AWSPushManager(forKey: ServiceKey).interceptApplication(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    /**
     * Handles callback from iOS platform indicating push notification registration failed.
     * - parameter application: application
     * - parameter error: error
     */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        AWSPushManager(forKey: ServiceKey).interceptApplication(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    /**
     * Handles a received push notification.
     * - parameter userInfo: push notification contents
     * - parameter completionHandler: Fetches updated content in background.  You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AWSPushManager(forKey: ServiceKey).interceptApplication(application, didReceiveRemoteNotification: userInfo)
    }
    
    /**
    * Configures all the enabled AWS services from application delegate with options.
    *
    * - parameter application: instance from application delegate.
    * - parameter launchOptions: from application delegate.
    */
    func didFinishLaunching(_ application: UIApplication, withOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        print("didFinishLaunching:")

        // Register the sign in provider instances with their unique identifier
        AWSSignInProviderFactory.sharedInstance().register(signInProvider: AWSFacebookSignInProvider.sharedInstance(), forKey: AWSFacebookSignInProviderKey)
        
        // set up Cloud Logic API invocation clients
        setupCloudLogicAPI()

            
        var didFinishLaunching: Bool = AWSIdentityManager.default().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)
        didFinishLaunching = didFinishLaunching && AWSPushManager(forKey: ServiceKey).interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)

        if (!isInitialized) {
            AWSIdentityManager.default().resumeSession(completionHandler: { (result: Any?, error: Error?) in
                print("Result: \(result) \n Error:\(error)")
            }) // If you get an EXC_BAD_ACCESS here in iOS Simulator, then do Simulator -> "Reset Content and Settings..."
               // This will clear bad auth tokens stored by other apps with the same bundle ID.
            isInitialized = true
        }
   
        return didFinishLaunching
    }
    
    func setupCloudLogicAPI() {
        let serviceConfiguration = AWSServiceConfiguration(region: AWSCloudLogicDefaultRegion, credentialsProvider: AWSIdentityManager.default().credentialsProvider)
        AWSAPI_ADI48J5BXK_MeetzambackendMobileHubClient.register(with: serviceConfiguration!, forKey: AWSCloudLogicDefaultConfigurationKey)
    }

}
