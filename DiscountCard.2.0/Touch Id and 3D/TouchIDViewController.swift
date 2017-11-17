//
//  TouchIDViewController.swift
//  DiscountCard.2.0
//
//  Created by Andrii Antoniak on 11/10/17.
//  Copyright © 2017 Andrii Antoniak. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDViewController: UIViewController {

    func currentPasswordFunc(){
        let defaults = UserDefaults.standard
        let savedPassword = defaults.object(forKey: "currentPassword") as! String?
        
        if let newpassword = savedPassword{
            currentPassword = newpassword
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        currentPasswordFunc()
        
        print("111")
        print(currentPassword)
        
        touchID()
       
        
    }
    
   
    
    func touchID(){
        
        let context = LAContext()
        
         var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Because we need!", reply: {(issuccessfull,error) in
                if issuccessfull{
                    self.goToTable()
                }else{
                    if let error = error as NSError?{
                        
                        switch error.code {
                        case LAError.userCancel.rawValue:
                            exit(0)
                        case LAError.userFallback.rawValue:
                                self.enterPassword()
                        default: break
                        }
                    }
                    self.enterPassword()
                }
            })
        }else{
                self.enterPassword()
        }
    }

    func goToTable(){
        let alert = UIAlertController(title: "DONE", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: {() in
            self.performSegue(withIdentifier: "fromTouchIDToTable", sender: nil)
        })
    }
    
    var password : UITextField?
    
    
    func enterPassword(){
        let passwordAlertController = UIAlertController(title: "Password", message: "Please,enter your password", preferredStyle: .alert)
  
        DispatchQueue.main.async {
            
        passwordAlertController.addTextField(configurationHandler: {(textField) in
            textField.isSecureTextEntry = true
            textField.text = ""
        })
       
       }
        
        passwordAlertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert:UIAlertAction) in
          
            let enteredPassword = passwordAlertController.textFields![0]
            if enteredPassword.text == currentPassword{
                self.goToTable()
            }else{
                exit(0)
            }
        }))
        
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction) in
            exit(0)
        })
        
        passwordAlertController.addAction(alertAction)
        
        DispatchQueue.main.async {
            self.present(passwordAlertController, animated: true, completion: nil)
        }
    
    }

    
    
   
    
    
    
    
    
    
    
}//end class