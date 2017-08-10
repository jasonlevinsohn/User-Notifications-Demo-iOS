//
//  ViewController.swift
//  Notifications-Demo
//
//  Created by jlev on 8/10/17.
//  Copyright © 2017 L3. All rights reserved.
//

import UIKit

import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 1. Request Permission from the user
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            
            if granted {
                print("Access Granted")
            } else {
                print(error?.localizedDescription ?? "Unknown Error Found")
            }
        })

    }
    
    @IBAction func notifyButtonTapped(sender: UIButton) {
        scheduleNotification(inSeconds: 5, completion: { success in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error scheduling notification")
            }
        })
    }
    
    func scheduleNotification(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        
        // Add an attachment
        guard let imageUrl = Bundle.main.url(forResource: "brutus", withExtension: "jpg") else {
            completion(false)
            return
        }
        
        var attachment: UNNotificationAttachment
        
        attachment = try! UNNotificationAttachment(identifier: "myNotif", url: imageUrl, options: .none)
        
        
        // Notification Content
        let notif = UNMutableNotificationContent()
        
        // We need this only for when we are using our own extension with custom interface
        notif.categoryIdentifier = "myNotificationCategory"
        
        notif.title = "New Notification"
        notif.subtitle = "These are great notifications!"
        notif.body = "The new notification options in iOS 10 are pretty cool"
        
        notif.attachments = [attachment]
        
        // Notification Trigger
        let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        
        // Notification Request
        let request = UNNotificationRequest(identifier: "myNotif", content: notif, trigger: notifTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            
            if error != nil {
                print(error as Any)
                completion(false)
            } else {
                completion(true)
            }
        })
        
        
    }

}

