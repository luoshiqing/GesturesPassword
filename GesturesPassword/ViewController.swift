//
//  ViewController.swift
//  GesturesPassword
//
//  Created by sqluo on 2017/3/24.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pwdV = PwdView(frame: self.view.bounds)
        
        pwdV.backgroundColor = UIColor.white
        
        self.view.addSubview(pwdV)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

