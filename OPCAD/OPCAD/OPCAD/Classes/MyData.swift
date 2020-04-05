//
//  MyData.swift
//  OPCAD
//
//  Created by Vijay Dhanda on 01/12/19.
//  Copyright © 2019 Vijay Dhanda. All rights reserved.
//

import UIKit

class MyData: NSObject {
    
    // variables id and password
    var id : String?
    var password : String?
    
    // constructor initWithData()
    func initWithData(i : String, p: String)
    {
        id = i
        password = p
    }
}
