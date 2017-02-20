//
//  PushNotificationViewController.swift
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

import Foundation
import UIKit
import AWSMobileHubHelper

class PushNotificationViewController: UIViewController {
    @IBOutlet weak var pushNotificationSwitch: UISwitch!
    @IBOutlet var tableView: UITableView!
    fileprivate var pushManager: AWSPushManager!
    // MARK:-  View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushManager = AWSPushManager(forKey: ServiceKey)
        pushManager?.delegate = self
        pushManager?.registerForPushNotifications()
        if let enabled = pushManager?.isEnabled {
            pushNotificationSwitch.isOn = enabled
        }
        
        if let topicARNs = pushManager?.topicARNs {
            pushManager.registerTopicARNs(topicARNs)
        }
    }
    
    // MARK:- IBActions
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            // Ask the user for permissions to receive push notifications.
            pushManager?.registerForPushNotifications()
        } else {
            // Unsubscribe from all topics
            let alertController = UIAlertController(title: NSLocalizedString("Please Confirm", comment: "Title bar for alert dialog about confirming disable push feature."), message: NSLocalizedString("Do you want to disable push notifications?", comment: "Message asking user if they want to disable push feature."), preferredStyle: .alert)
            let disableAction = UIAlertAction(title: NSLocalizedString("Disable", comment: "Disable Button on alert dialog."), style: .default, handler: {(action: UIAlertAction) -> Void in
                self.pushManager?.disablePushNotifications()
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button on alert dialog."), style: .default, handler: nil)
            alertController.addAction(disableAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK:- UITableViewDelegate

extension PushNotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = pushManager?.topics.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if pushManager?.isEnabled == true {
            if indexPath.row < pushManager.topics.count {
                let topic = pushManager.topics[indexPath.row]
                if topic.isSubscribed {
                    // Unsubscribe
                    let alertController = UIAlertController(title: "Please Confirm", message: "Do you want to unsubscribe from the topic?", preferredStyle: .alert)
                    let unsubscribeAction = UIAlertAction(title: "Unsubscribe", style: .default, handler: {(action: UIAlertAction) -> Void in
                        topic.unsubscribe()
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(unsubscribeAction)
                    alertController.addAction(cancelAction)
                    present(alertController, animated: true, completion: nil)
                } else {
                    // Subscribe
                    topic.subscribe()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return pushManager.isEnabled
    }
}

// MARK:- UITableViewDataSource

extension PushNotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AWSPushNotificationViewCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if indexPath.row < pushManager.topics.count {
            let topic = pushManager.topics[indexPath.row]
            cell.textLabel!.text = topic.topicName
            cell.detailTextLabel!.text = topic.topicARN
            cell.accessoryType = topic.isSubscribed ? .checkmark : .none
        }
        return cell
    }
}

// MARK:- AWSPushManagerDelegate

extension PushNotificationViewController: AWSPushManagerDelegate {
    func pushManagerDidRegister(_ pushManager: AWSPushManager) {
        print("Successfully enabled Push Notifications.")
        pushNotificationSwitch.isOn = pushManager.isEnabled
        // Subscribe the first topic among the configured topics (all-device topic)
        if let defaultSubscribeTopic = pushManager.topicARNs?.first {
            let topic = pushManager.topic(forTopicARN: defaultSubscribeTopic)
            topic.subscribe()
        }
    }
    
    func pushManager(_ pushManager: AWSPushManager, didFailToRegisterWithError error: Error) {
        pushNotificationSwitch.isOn = false
        showAlertWithTitle("Error", message: "Failed to enable Push Notifications.")
    }
    
    func pushManager(_ pushManager: AWSPushManager, didReceivePushNotification userInfo: [AnyHashable: Any]) {
        DispatchQueue.main.async(execute: {
            print("Received a Push Notification: \(userInfo)")
            self.showAlertWithTitle("Received a Push Notification.", message: userInfo.description)
        })
    }
    
    func pushManagerDidDisable(_ pushManager: AWSPushManager) {
        print("Successfully disabled Push Notification.")
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func pushManager(_ pushManager: AWSPushManager, didFailToDisableWithError error: Error) {
        print("Failed to subscibe to a topic: \(error)")
        showAlertWithTitle("Error", message: "Failed to unsubscribe from all the topics.")
    }
}

// MARK:- AWSPushTopicDelegate

extension PushNotificationViewController: AWSPushTopicDelegate {
    
    func topicDidSubscribe(_ topic: AWSPushTopic) {
        print("Successfully subscribed to a topic: \(topic.topicName)")
        tableView.reloadData()
    }
    
    func topic(_ topic: AWSPushTopic, didFailToSubscribeWithError error: Error) {
        print("Failed to subscribe to topic: \(topic.topicName)")
        showAlertWithTitle("Error", message: "Failed to subscribe to \(topic.topicName)")
    }
    
    func topicDidUnsubscribe(_ topic: AWSPushTopic) {
        print("Successfully unsubscribed from a topic: \(topic)")
        self.tableView.reloadData()
    }
    
    func topic(_ topic: AWSPushTopic, didFailToUnsubscribeWithError error: Error) {
        print("Failed to subscribe to a topic: \(error)")
        showAlertWithTitle("Error", message: "Failed to unsubscribe from : \(topic.topicName)")
    }
}

// MARK:- Utility methods

extension PushNotificationViewController {

    fileprivate func showAlertWithTitle(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}