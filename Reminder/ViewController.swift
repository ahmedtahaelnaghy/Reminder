//
//  ViewController.swift
//  Reminder
//
//  Created by Ahmed Taha on 10/04/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var taskTextField: UITextField!
    
    var center: UNUserNotificationCenter!
    
    var isNotificationEnabled: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound]) { (userResponse, error) in
            
            switch userResponse {
                
            case true:
                self.isNotificationEnabled = true
                
            case false:
                self.isNotificationEnabled = false
                
            }
            
            if let error = error {
                
                print(error.localizedDescription)
                
            }
            
        }
        
    }
    
    @IBAction func setReminderBtn(_ sender: Any) {
        
        if isNotificationEnabled == true {
            
            let name = taskTextField.text!
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "\(name)"
            content.sound = .default
            
            let time = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: datePicker.date)
            let triggleTimer = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
            let request = UNNotificationRequest(identifier: "TaskReminder", content: content, trigger: triggleTimer)
            
            center.add(request) { (error) in
                
                if let error = error {
                    
                    print("Error is \(error.localizedDescription)")
                    
                }
                
                
            }
            
            
        }else {
            
            let alertController = UIAlertController(title: "Alert", message: "Enable Notifications From Settings!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(action)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        completionHandler([.alert, .sound])
        
    }
    
    
}



