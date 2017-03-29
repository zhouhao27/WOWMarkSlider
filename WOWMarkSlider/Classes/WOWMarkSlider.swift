import UIKit

@IBDesignable
open class WOWMarkSlider: UISlider {
    
    open var markPositions: [Float]?
    
    @IBInspectable
    open var markWidth : CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var markColor : UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var selectedBarColor: UIColor = UIColor.darkGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable
    open var unselectedBarColor: UIColor = UIColor.lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var handlerImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var handlerColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
        
    open var lineCap: CGLineCap = .round {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var height: CGFloat = 12.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: view life circle
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        setup()
    }
    
    // MARK: local functions
    func setup() {
        
    }
    
    // MARK: drawing
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // We create an innerRect in which we paint the lines
        let innerRect = rect.insetBy(dx: 1.0, dy: 10.0)
        
        UIGraphicsBeginImageContextWithOptions(innerRect.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            // Selected side
            context.setLineCap(lineCap)
            context.setLineWidth(height)
            context.move(to: CGPoint(x:height/2, y:innerRect.height/2))
            context.addLine(to: CGPoint(x:innerRect.size.width - 10, y:innerRect.height/2))
            context.setStrokeColor(self.selectedBarColor.cgColor)
            context.strokePath()
            
            let selectedSide = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
            
            // Unselected side
            context.setLineCap(lineCap)
            context.setLineWidth(height)
            context.move(to: CGPoint(x: height/2, y: innerRect.height/2))
            context.addLine(to: CGPoint(x: innerRect.size.width - 10,y: innerRect.height/2))
            context.setStrokeColor(self.unselectedBarColor.cgColor)
            context.strokePath()
            
            let unselectedSide = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
            
            
            // Set strips on selected side
            selectedSide?.draw(at: CGPoint.zero)
            
            if let positions = self.markPositions {
                for i in 0..<positions.count {
                    context.setLineWidth(self.markWidth)
                    let position = CGFloat(positions[i]) * innerRect.size.width / 100.0
                    context.move(to: CGPoint(x:position, y:innerRect.height/2 - (height/2 - 1)))
                    context.addLine(to: CGPoint(x:position, y:innerRect.height/2 + (height/2 - 1)))
                    context.setStrokeColor(self.markColor.cgColor)
                    context.strokePath()
                }
            }
            
            let selectedStripSide = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
            
//            context.clear(rect)
            
            // Set trips on unselected side
            unselectedSide?.draw(at: CGPoint.zero)
            if let positions = self.markPositions {
                for i in 0..<positions.count {
                    context.setLineWidth(self.markWidth)
                    let position = CGFloat(positions[i])*innerRect.size.width/100.0
                    context.move(to: CGPoint(x:position,y:innerRect.height/2-(height/2 - 1)))
                    context.addLine(to: CGPoint(x:position,y:innerRect.height/2+(height/2 - 1)))
                    context.setStrokeColor(self.markColor.cgColor)
                    context.strokePath()
                }
            }
            
            let unselectedStripSide = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
            
            context.clear(rect)
            UIGraphicsEndImageContext()
            
            setMinimumTrackImage(selectedStripSide, for: .normal)
            setMaximumTrackImage(unselectedStripSide, for: .normal)
            if handlerImage != nil {
                setThumbImage(handlerImage, for: .normal)
            } else {
                setThumbImage(UIImage(), for: .normal)
                thumbTintColor = handlerColor
            }
        }
    }
    
}
