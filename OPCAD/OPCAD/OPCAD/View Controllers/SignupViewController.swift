//
//  SignupViewController.swift
//  OPCAD
//
//  Created by Vijay Dhanda on 01/12/19.
//  Copyright © 2019 Vijay Dhanda. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var tfId_s : UITextField!
    @IBOutlet var tfPassword_s : UITextField!
    @IBOutlet var btSignUp_s : UIButton!
    
    @IBAction func SignUpButtonPressed(sender : UIButton)
    {
        // instantiate Data object and add textfield data
        let user : MyData = MyData.init()
        user.initWithData(i: tfId_s.text!, p: tfPassword_s.text!)
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // inserting into db
        let returnCode : Bool = mainDelegate.insertIntoDatabase(users: user)
        
        // show alert box to indicate success/fail
        var returnMSG : String = "User has been added"
        if returnCode == false
        {
            returnMSG = "Failed to register user"
        }
        
        let alertController = UIAlertController(title: "SQLite Add", message: returnMSG, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    // function to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfId_s.layer.cornerRadius = 10
        tfId_s.clipsToBounds = true
        tfPassword_s.layer.cornerRadius = 10
        tfPassword_s.clipsToBounds = true
        btSignUp_s.layer.cornerRadius = 10
        btSignUp_s.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
