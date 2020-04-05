//
//  ViewController.swift
//  OPCAD
//
//  Created by Vijay Dhanda on 01/12/19.
//  Copyright © 2019 Vijay Dhanda. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController, UITextFieldDelegate {
    
    // add textfield variables  and buttons - connect to storyboard
    @IBOutlet var tfId : UITextField!
    @IBOutlet var tfPassword : UITextField!
    @IBOutlet var lblLogin : UILabel!
    @IBOutlet var lblSignup : UILabel!
    @IBOutlet var lblRecover : UILabel!
    
    
    // function for the back button
    @IBAction func unwindtoHomeViewController(sender: UIStoryboardSegue)
    {
    
    }
    
    // function to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    // create touch method for navigating to sub pages
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    // this is an alternative way to touching the screen.
    // It is executed when a user touches the screen
    // at which point a set of touches are returned - each containing pixel locations
    // grab 1 pixel out of the bunch
        let touch : UITouch = touches.first!
    // convert it to an x,y location -> CGPoint type
        let touchPoint : CGPoint = touch.location(in: self.view!)
     
    // get rectangles of both labels on screen that were touchable
        let loginFrame : CGRect = lblLogin.frame
        let signupFrame : CGRect = lblSignup.frame
        let recoveryFrame : CGRect = lblRecover.frame
     
    // check and see if point is within either rectangle
    // call segue to either page.
        if loginFrame.contains(touchPoint)
        {
            let user : MyData = MyData.init()
            user.initWithData(i: tfId.text!, p: tfPassword.text!)
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            
            // inserting into db
            let returnCode : Bool = mainDelegate.checkUserCredentials(users: user)

            
            if returnCode == false
            {
                let returnMSG : String = "User not found"
                
                let alertController = UIAlertController(title: "OPCAD", message: returnMSG, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                
                alertController.addAction(cancelAction)
                present(alertController, animated: true)
            }
                
            else
            {
                //save data before segue
                performSegue(withIdentifier: "HomeSegueToMainMenu", sender: self)
            }

        }
        
        if signupFrame.contains(touchPoint)
        {
            performSegue(withIdentifier: "HomeSegueToSignup", sender: self)
        }
        
        if recoveryFrame.contains(touchPoint)
        {
            performSegue(withIdentifier: "HomeSegueToRecovery", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //rounded corners for label
        lblLogin.layer.cornerRadius = 10
        lblLogin.clipsToBounds = true
        lblSignup.layer.cornerRadius = 10
        lblSignup.clipsToBounds = true
        
        tfId.layer.cornerRadius = 10
        tfId.clipsToBounds = true
        tfPassword.layer.cornerRadius = 10
        tfPassword.clipsToBounds = true
    }


}

