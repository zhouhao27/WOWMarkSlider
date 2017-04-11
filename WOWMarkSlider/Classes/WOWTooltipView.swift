//
//  WOWTooltipView.swift
//  Pods
//
//  Created by Zhou Hao on 11/4/17.
//
//

import UIKit

open class WOWTooltipView: UIView {

    // MARK: properties
    var font: UIFont = UIFont.boldSystemFont(ofSize: 18.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var value: Float {
        get {
            if let text = text {
                return Float(text) ?? 0
            }
            return 0.0
        }
        set {
            text = String(format: "%.2f",newValue)
        }
    }
    
    var fillColor = UIColor(white: 0, alpha: 0.8) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var textColor = UIColor(white: 1.0, alpha: 0.8) {
        didSet {
            setNeedsDisplay()
        }
    }
        
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        fillColor.setFill()
        
        let roundedRect = CGRect(x:bounds.origin.x, y:bounds.origin.y, width:bounds.size.width, height:bounds.size.height * 0.8)
        let roundedRectPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: 6.0)
        
        // create arrow
        let arrowPath = UIBezierPath()
        
        let p0 = CGPoint(x: bounds.midX, y: bounds.maxY - 2.0 )
        arrowPath.move(to: p0)
        arrowPath.addLine(to: CGPoint(x:bounds.midX - 6.0, y: roundedRect.maxY))
        arrowPath.addLine(to: CGPoint(x:bounds.midX + 6.0, y: roundedRect.maxY))
        
        roundedRectPath.append(arrowPath)
        roundedRectPath.fill()
        
        // draw text 
        if let text = self.text {
            
            let size = text.size(attributes: [NSFontAttributeName: font])
            let yOffset = (roundedRect.size.height - size.height) / 2.0
            let textRect = CGRect(x:roundedRect.origin.x, y: yOffset, width: roundedRect.size.width, height: size.height)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs = [NSFontAttributeName: font,
                         NSParagraphStyleAttributeName: paragraphStyle,
                         NSForegroundColorAttributeName: textColor] as [String : Any]
            text.draw(in:textRect, withAttributes: attrs)
        }
    }

}
