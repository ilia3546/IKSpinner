//
//  IKSpinner.swift
//  IKSpinner
//
//  Created by Ilya Kharlamov on 08/02/2017.
//  Copyright (c) 2017 Ilya Kharlamov. All rights reserved.
//

import UIKit

@IBDesignable
open class IKSpinner: UIView{
    
    
    //MARK: - Appearance
    
    @IBInspectable open var isAnimating: Bool = false{
        didSet{
            self.isHidden = !isAnimating
            if isAnimating {
                start()
            }else{
                stop()
            }
        }
    }
    
    @IBInspectable open var lineWidth: CGFloat = 2{
        didSet{
            self.backgroundLayer?.lineWidth = self.lineWidth
        }
    }
    
    @IBInspectable open var lineColor: UIColor = .darkGray{
        didSet{
            self.backgroundLayer?.strokeColor = lineColor.cgColor
        }
    }
    
    @IBInspectable open var rotateSpeed: Double = 1{
        didSet{
            stop()
            start()
        }
    }
    
    private var backgroundLayer : CAShapeLayer?

    //MARK: - Init methods

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override open func draw(_ rect: CGRect) {
        self.backgroundLayer?.frame = self.bounds
        self.drawBackgroundCircle()
    }
    
    private func setup(){
        
        if self.backgroundColor == nil{
            self.backgroundColor = UIColor.clear
        }
        

        self.isHidden = !self.isAnimating
        self.backgroundLayer = CAShapeLayer()
        self.backgroundLayer?.lineCap = kCALineCapRound
        self.backgroundLayer?.lineWidth = self.lineWidth
        self.backgroundLayer?.fillColor = UIColor.clear.cgColor
        self.backgroundLayer?.strokeColor = lineColor.cgColor
        
        self.layer.addSublayer(self.backgroundLayer!)




    }
    
    
    open func fadeIn(_ durutation:TimeInterval = 0.2, _ onComplection:(()->Void)? = nil){

        self.isAnimating = true
        
        self.alpha = 0
        UIView.animate(withDuration: durutation, animations: {
            self.alpha = 1
        }) { (finished) in
            if let onComplection = onComplection { onComplection() }
        }
    }
    
    open func fadeOut(_ durutation:TimeInterval = 0.2, _ onComplection:(()->Void)? = nil){
        UIView.animate(withDuration: durutation, animations: {
            self.alpha = 0
        }) { (finished) in
            self.isAnimating = false
            if let onComplection = onComplection { onComplection() }
        }
    }
    
    
    @objc private func start() {
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1 / self.rotateSpeed;
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = HUGE;
        self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        
        NotificationCenter.default.addObserver(self, selector: #selector(start), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    
    private func stop() {
        self.backgroundLayer?.removeAllAnimations()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    

    private func drawBackgroundCircle() {
        
        let baseAngle = CGFloat(Double.pi) / CGFloat(2.0)
        
        let startAngle1 : CGFloat = baseAngle
        let endAngle1 : CGFloat = 2 * baseAngle
        let startAngle2 : CGFloat = 3 * baseAngle
        let endAngle2 : CGFloat = 4 * baseAngle
        
        let center : CGPoint = CGPoint(x: self.bounds.size.width / 2,y: self.bounds.size.height / 2)
        
        let radius : CGFloat = (CGFloat(min(self.bounds.size.width, self.bounds.size.height)) - self.lineWidth) / CGFloat(2.0)
        
        let processBackgroundPath1 : UIBezierPath = UIBezierPath()
        processBackgroundPath1.lineWidth = self.lineWidth
        processBackgroundPath1.addArc(withCenter: center, radius: radius, startAngle: startAngle1, endAngle: endAngle1, clockwise: true)
        
        let processBackgroundPath2 : UIBezierPath = UIBezierPath()
        processBackgroundPath2.lineWidth = self.lineWidth
        processBackgroundPath2.addArc(withCenter: center, radius: radius, startAngle: startAngle2, endAngle: endAngle2, clockwise: true)

        processBackgroundPath1.append(processBackgroundPath2)
        
        self.backgroundLayer?.path = processBackgroundPath1.cgPath;
    }
    
}
