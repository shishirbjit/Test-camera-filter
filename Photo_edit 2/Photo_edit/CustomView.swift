//
//  RoundedViewWithGrayBorder.swift
//  khalifauniversity
//
//  Created by ROYEX on 4/8/19.
//  Copyright © 2019 Royex. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable open dynamic var BorderColor : UIColor = UIColor.gray{
        didSet{
            
            self.reloadStyle()
        }
    }
    
    @IBInspectable open dynamic var BorderWidth : CGFloat = 0.5 {
        
        didSet{
            
            self.reloadStyle()
        }
    }
    
    @IBInspectable open dynamic var CornorRadious : CGFloat  = 4 {
        didSet{
            
            self.reloadStyle()
        }
    }
    
    @IBInspectable open dynamic var isTopCornorRadius : Bool = false
    @IBInspectable open dynamic var TopCornorRadius : CGFloat = 4.0
    
    @IBInspectable open dynamic var isBottomCornorRadius : Bool = false
    @IBInspectable open dynamic var BottomCornorRadius : CGFloat = 4.0
    
    
    @IBInspectable open dynamic var isShadow : Bool  = false{
        didSet{
            
            self.reloadStyle()
        }
    }
    
    @IBInspectable open dynamic var isClickable : Bool  = false{
        didSet{
            
            // self.addGesture()
        }
    }
    
    @IBInspectable open dynamic var isClickAnimation : Bool = false
    
    @IBInspectable open dynamic var ClickAnimationColor : UIColor = #colorLiteral(red: 0.8980392157, green: 0.8941176471, blue: 0.9137254902, alpha: 1)
    
    @IBInspectable open dynamic var ShadowColor : UIColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1){
        didSet{
            self.reloadStyle()
        }
    }
    
    @IBInspectable open dynamic var ShadowOpacity : Float = Float(1){
        didSet{
            self.reloadStyle()
        }
    }
    
    @IBInspectable open dynamic var ShadowRadius : CGFloat =  CGFloat(5){
        didSet{
            self.reloadStyle()
        }
    }
    
    @IBInspectable open dynamic var ShadowOffset : CGSize = CGSize(width: CGFloat(5), height: CGFloat(5)){
        didSet{
            self.reloadStyle()
        }
    }
    
    var customBackground : UIColor?
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.reloadStyle()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        
        if self.isClickAnimation {
            
            self.backgroundColor = ClickAnimationColor
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if self.isClickAnimation {
            
            self.backgroundColor = ClickAnimationColor
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
            
            guard let delegate = self.delegate else { return }
            
            delegate.tapedView(view: self)
            
        })
        
        if self.isClickAnimation {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
                
                guard let self = self else { return }
                
                self.tapOutAnimation()
                
            }
        }
        
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if self.isClickAnimation {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                
                self?.tapOutAnimation()
                
            }
        }
        
    }
    
    weak open var delegate : CustomViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customBackground = self.backgroundColor
        self.reloadStyle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reloadStyle()
    }
    
    private func reloadStyle(){
        
        DispatchQueue.main.async {
            
            self.layer.cornerRadius = CGFloat(self.CornorRadious)
            self.layer.borderColor = self.BorderColor.cgColor
            self.layer.borderWidth = CGFloat(self.BorderWidth)
            
            
            if self.isShadow{
                
                self.layer.shadowColor = self.ShadowColor.cgColor
                self.layer.shadowOffset = self.ShadowOffset
                self.layer.shadowRadius = self.ShadowRadius
                self.layer.shadowOpacity = self.ShadowOpacity
                
                
            }else{
                
                self.layer.shadowColor = UIColor.clear.cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.layer.shadowRadius = CGFloat(0)
                self.layer.shadowOpacity = 0.0
            }
            
            if self.isTopCornorRadius {
                
                
                self.roundCorners(corners: [.topLeft,.topRight], radius: self.TopCornorRadius)
                
            }
            
            if self.isBottomCornorRadius {
                
                self.roundCorners(corners: [.bottomRight,.bottomLeft], radius: self.BottomCornorRadius)
                
                
            }
            
            
        }
        
        
    }
    
    private func tapOutAnimation(){
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear,.curveEaseOut], animations: {
            
            self.backgroundColor = self.customBackground ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }, completion: nil)
        
    }
    
}


protocol CustomViewDelegate : class {
    
    func tapedView(view : UIView?)
    
}


extension CustomView {
    
    public func animateBorderWidth(toValue: CGFloat, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = layer.borderWidth
        animation.toValue = toValue
        animation.duration = duration
        layer.add(animation, forKey: "Width")
        layer.borderWidth = toValue
    }
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

