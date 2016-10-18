//
//  SSClickButtonSwift.swift
//  SSClickButton-swift
//
//  Created by haohao on 16/10/18.
//  Copyright © 2016年 haohao. All rights reserved.
//

import UIKit
typealias TransferNumberClosure = (_ textFieldText : String?) -> Void

class SSClickButtonSwift: UIView, UITextFieldDelegate {
    //累加的按钮
    private lazy var addButton: UIButton = {
        let addButton = UIButton.init(type: .custom)
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.gray, for: .normal)
        return addButton
    }()
    
    //累减的按钮
    private lazy var subtractButton: UIButton = {
        let subtractButton = UIButton.init(type: .custom)
        subtractButton.setTitle("-", for: .normal)
        subtractButton.setTitleColor(UIColor.gray, for: .normal)
        return subtractButton
    }()
    
    //显示的输入框
    private lazy var showTextField: UITextField = {
       let showTextField = UITextField.init()
        showTextField.text = "1"
        showTextField.font = UIFont.systemFont(ofSize: 15)
        showTextField.keyboardType = .numberPad
        showTextField.textAlignment = .center
        return showTextField
    }()
    
    var timer : Timer?
    var transferNumberClosure : TransferNumberClosure?
    
    var _bordColor : UIColor?
    var bordColor : UIColor? {
        set {
            _bordColor = newValue
            self.layer.borderColor = _bordColor?.cgColor
            addButton.layer.borderColor = _bordColor?.cgColor
            subtractButton.layer.borderColor = _bordColor?.cgColor
            
            self.layer.borderWidth = 0.5
            addButton.layer.borderWidth = 0.5
            subtractButton.layer.borderWidth = 0.5
        }
        get {
            return _bordColor
        }
    }
    
    var _fontSize : CGFloat?
    var fontSize : CGFloat? {
        set {
            _fontSize = newValue
            showTextField.font = UIFont.systemFont(ofSize: _fontSize!)
        }
        get {
            return _fontSize
        }
    }
    
    
    //MARK: ------- 类方法创建
    class func shareClickButtonWithFrame(frame :  CGRect) -> SSClickButtonSwift {
        return SSClickButtonSwift.init(frame: frame)
    }
    
    //MARK: ------- init
    override init(frame: CGRect) {
       super.init(frame: frame)
        creatUI()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        creatUI()
    }
    
    //MARK: ------ 创建各个控件
    private func creatUI() {
        self.backgroundColor = UIColor.white
        self.addSubview(addButton)
        self.addSubview(subtractButton)
        self.addSubview(showTextField)
        showTextField.delegate = self
        addButton.addTarget(self, action: #selector(SSClickButtonSwift.touchDown(sender:)), for: .touchDown)
        addButton.addTarget(self, action: #selector(SSClickButtonSwift.touchCancel(sender:)), for: [.touchCancel, .touchUpInside, .touchUpOutside])
        subtractButton.addTarget(self, action: #selector(SSClickButtonSwift.touchDown(sender:)), for: .touchDown)
        subtractButton.addTarget(self, action: #selector(SSClickButtonSwift.touchCancel(sender:)), for: [.touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    //点击不送开
    @objc private func touchDown(sender : UIButton) {
        showTextField.resignFirstResponder()
        //创建定时器
        if sender == addButton {
            self.timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(SSClickButtonSwift.add), userInfo: nil, repeats: true)
        }else{
            self.timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(SSClickButtonSwift.subtract), userInfo: nil, repeats: true)
        }
        if self.timer != nil {
            self.timer?.fire()
        }
    }
    
    @objc private func add() {
        let number = Int(showTextField.text!)! + 1
        showTextField.text = "\(number)"
        if self.transferNumberClosure != nil {
            self.transferNumberClosure!(showTextField.text!)
        }
    }
    
    @objc private func subtract() {
        let number = Int(showTextField.text!)! - 1
        if number > 0 {
            showTextField.text = "\(number)"
        }else{
            //抖动动画
            self.shakeTheAnimation()
        }
        if self.transferNumberClosure != nil {
            self.transferNumberClosure!(showTextField.text!)
        }
    }
    
    @objc private func touchCancel(sender : UIButton) {
        //销毁定时器
        if self.timer != nil {
            if self.timer!.isValid {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subtractButton.frame = CGRect(x: 0,y: 0, width: self.frame.height, height: self.frame.height)
        addButton.frame = CGRect(x: self.frame.width - self.frame.height,y: 0, width: self.frame.height, height: self.frame.height)
        showTextField.frame = CGRect(x: self.frame.height, y: 0, width: self.frame.width - 2 * self.frame.height, height: self.frame.height)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let number = Int(textField.text!)
        if number! <= 0 {
            textField.text = "1"
        }
        if self.transferNumberClosure != nil {
            self.transferNumberClosure!(textField.text!)
        }
    }
    
    //MARK: ------ 抖动动画
    private func shakeTheAnimation() {
        let animation = CAKeyframeAnimation.init(keyPath: "position.x")
        let defaultPositonX = self.layer.position.x
        animation.values = [defaultPositonX - 10, defaultPositonX, defaultPositonX + 10]
        animation.repeatCount = 3
        animation.duration = 0.05
        animation.autoreverses = true
        self.layer.add(animation, forKey: "shakeAnimation")
    }
    
    //MARK: ------- 设置按钮的背景图片和title，字体大小
    func setClickButtonBackGroundImageWithTitle(subtractImage : UIImage?, subtractTitle : String?, addButtonImage: UIImage?, addButtonTitle : String?, buttonFontSize : CGFloat?) {
        if subtractImage != nil {
            subtractButton.setBackgroundImage(subtractImage, for: .normal)
        }
        if subtractTitle != nil {
            subtractButton.setTitle(subtractTitle, for: .normal)
        }
        
        if addButtonImage != nil {
            addButton.setBackgroundImage(addButtonImage, for: .normal)
        }
        
        if addButtonTitle != nil {
            addButton.setTitle(addButtonTitle, for: .normal)
        }
        
        if buttonFontSize != nil {
            addButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize!)
            subtractButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize!)
        }
    }
    
    func setButtonForeGroundImage(subtractImage : UIImage?, addImage : UIImage?) {
        if subtractImage != nil {
            subtractButton.setTitle("", for: .normal)
            subtractButton.setImage(subtractImage, for: .normal)
        }
        
        if addImage != nil {
            addButton.setTitle("", for: .normal)
            addButton.setImage(addImage, for: .normal)
        }
    }
    
    //MARK: ------- 设置按钮的图片
    override func draw(_ rect: CGRect) {
        
    }

}
