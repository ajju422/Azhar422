//
//  Utils.swift
//  HeroKuApp
//
//  Created by Azhar on 25/01/19.
//  Copyright © 2019 Orbysol Systems Pvt Ltd. All rights reserved.
//

import UIKit

class Utils: NSObject {

    func validateEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
