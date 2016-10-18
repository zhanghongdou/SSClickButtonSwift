//
//  ViewController.swift
//  SSClickButton-swift
//
//  Created by 爱利是 on 16/10/18.
//  Copyright © 2016年 haohao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sbClickBtn: SSClickButtonSwift!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 0.9373, green: 0.9373, blue: 0.9569, alpha: 1)
        let btn = SSClickButtonSwift.shareClickButtonWithFrame(frame: CGRect(x: 100, y: 100, width: 110, height: 30))
        btn.transferNumberClosure = {(textFieldText : String?) in
            print(textFieldText!)
        }
        self.view.addSubview(btn)
        
        
        self.sbClickBtn.bordColor = UIColor.orange
        self.sbClickBtn.transferNumberClosure = {(textFieldText : String?) in
            print(textFieldText!)
        }
        
        let btn2 = SSClickButtonSwift.shareClickButtonWithFrame(frame: CGRect(x: 100, y: 300, width: 110, height: 30))
        btn2.setButtonForeGroundImage(subtractImage: UIImage.init(named: "subtract"), addImage: UIImage.init(named: "add"))
        self.view.addSubview(btn2)
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

