import UIKit

public protocol WOWMarkSliderDelegate: class {
    func startDragging(slider: WOWMarkSlider)
    func endDragging(slider: WOWMarkSlider)
    func markSlider(slider: WOWMarkSlider, dragged to: Float)
}

@IBDesignable
open class WOWMarkSlider: UISlider {
    
    open weak var delegate: WOWMarkSliderDelegate?
    
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
    
    private var toolTipView: WOWTooltipView!
    
    var thumbRect: CGRect {
        let rect = trackRect(forBounds: bounds)
        return thumbRect(forBounds: bounds, trackRect: rect, value: value)
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
        toolTipView = WOWTooltipView(frame: CGRect.zero)
        toolTipView.backgroundColor = UIColor.clear
        self.addSubview(toolTipView)
    }
    
    // MARK: UIControl touch event tracking
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        delegate?.startDragging(slider: self)
        // Fade in and update the popup view
        let touchPoint = touch.location(in: self)
        // Check if the knob is touched. Only in this case show the popup-view
        if thumbRect.contains(touchPoint) {
            positionAndUpdatePopupView()
            fadePopupViewInAndOut(fadeIn: true)
        }
        return super.beginTracking(touch, with: event)
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // Update the popup view as slider knob is being moved
        positionAndUpdatePopupView()
        return super.continueTracking(touch, with: event)
    }
    
    open override func cancelTracking(with event: UIEvent?) {
        delegate?.endDragging(slider: self)
        super.cancelTracking(with: event)
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        // Fade out the popoup view
        delegate?.endDragging(slider: self)
        delegate?.markSlider(slider: self, dragged: value)
        fadePopupViewInAndOut(fadeIn: false)
        super.endTracking(touch, with: event)
    }
    
    private func positionAndUpdatePopupView() {
        
        let tRect = thumbRect
        let popupRect = tRect.offsetBy(dx: 0, dy: -(tRect.size.height * 1.5))
        toolTipView.frame = popupRect.insetBy(dx: -20, dy: -10)
        toolTipView.value = value
    }
    
    private func fadePopupViewInAndOut(fadeIn: Bool) {

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        if fadeIn {
            toolTipView.alpha = 1.0
        } else {
            toolTipView.alpha = 0.0
        }
        UIView.commitAnimations()
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
