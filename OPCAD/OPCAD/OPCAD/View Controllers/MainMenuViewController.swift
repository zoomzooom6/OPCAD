//
//  MainMenuViewController.swift
//  OPCAD
//
//  Created by Vijay Dhanda on 01/12/19.
//  Copyright © 2019 Vijay Dhanda. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController{
    
    
    @IBOutlet weak var myButton1: UIButton!
    @IBOutlet weak var myButton2: UIButton!
    @IBOutlet weak var myButton3: UIButton!
    @IBOutlet weak var myButton4: UIButton!
    @IBOutlet var mapLoc: UIImageView!
    
    
    // function for the back button
    @IBAction func unwindtoMainMenuViewController(sender: UIStoryboardSegue)
        
        {
       
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myButton1.layer.cornerRadius = 10
        myButton1.clipsToBounds = true
        myButton2.layer.cornerRadius = 10
        myButton2.clipsToBounds = true
        myButton3.layer.cornerRadius = 10
        myButton3.clipsToBounds = true
        myButton4.layer.cornerRadius = 10
        myButton4.clipsToBounds = true
      
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
