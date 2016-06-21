import UIKit

@IBDesignable class DesignableImageView: UIImageView{}

@IBDesignable class DesignableButton: UIButton{}

@IBDesignable class DesignableTextView: UITextField{
	
	@IBInspectable
	var placeholderTextColor: UIColor = UIColor.lightGrayColor(){
	didSet{
	guard let placeholder = placeholder else{
	return
	}
	attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
	[NSForegroundColorAttributeName : placeholderTextColor])
	}
	}
}
/*

extension UITextField{
    @IBInspectable
    var placeholderTextColor: UIColor = UIColor.darkGrayColor(){
        didSet{
            guard let placeholder = placeholder else{
                return
            }
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
                [NSForegroundColorAttributeName : placeholderTextColor])
        }
    }
}*/

class UnderlinedLabel: UILabel {
    
    @IBInspectable var leftLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var rightLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var bottomLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var topLine: Bool = false { didSet{ drawLines() } }
    
    func drawLines(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        //UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0).CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        border.borderWidth = width
        layer.addSublayer(border)
    }
}



extension UIView {
	

	@IBInspectable
	var borderWidth: CGFloat{
	get {
	return layer.borderWidth
	}
	set(newBoarderWidth){
	layer.borderWidth = newBoarderWidth
	}
	}

	@IBInspectable
	var borderColor: UIColor?{
	get {
	return layer.borderColor != nil ? UIColor(CGColor: layer.borderColor!) : nil
	}
	set {
	layer.borderColor = newValue?.CGColor
	}
	}
	@IBInspectable
	var cornerRadius: CGFloat{
	get{
	return layer.cornerRadius
	}
	set{
	layer.cornerRadius = newValue
	layer.masksToBounds = newValue != 0
	}
	}
    
 

	
}

extension UIStackView {
    
    
    @IBInspectable
    var stackBorderWidth: CGFloat{
        get {
            return layer.borderWidth
        }
        set(newBoarderWidth){
            layer.borderWidth = newBoarderWidth
        }
    }
    
    @IBInspectable
    var stackBorderColor: UIColor?{
        get {
            return layer.borderColor != nil ? UIColor(CGColor: layer.borderColor!) : nil
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    @IBInspectable
    var stackCornerRadius: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }
    
    
    
    
}

// from https://forums.developer.apple.com/thread/14468
extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        //let context = UIGraphicsGetCurrentContext() as CGContextRef
        //error: 'CGContext?' is not convertible to 'CGContextRef'
        //CGContextRef == CGContext, so it's saying "'CGContext?' is not convertible to 'CGContext'"
        //->you just need to unwrap it
        let context = UIGraphicsGetCurrentContext()!
        
        
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        //CGContextSetBlendMode(context, kCGBlendModeNormal)
        //error: use of unresolved identifier 'kCGBlendModeNormal'
        //->See the CGBlendMode constants in the CGContext Reference, it's got enum.
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage  
    }  
}

 
// added some uicolor to hex thing from https://gist.github.com/arshad/de147c42d7b3063ef7bc

extension UIColor {
    // Creates a UIColor from a Hex string.
    convenience init(hexString: String) {
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            self.init(white: 0.5, alpha: 1.0)
        } else {
            let rString: String = (cString as NSString).substringToIndex(2)
            let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
            let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
            
            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
            NSScanner(string: rString).scanHexInt(&r)
            NSScanner(string: gString).scanHexInt(&g)
            NSScanner(string: bString).scanHexInt(&b)
            
            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
        
        
    }
}
class Underlined: UITextField {
    
   
    
    @IBInspectable var leftLine: Bool = true { didSet{ drawLines() } }
    @IBInspectable var rightLine: Bool = true { didSet{ drawLines() } }
    @IBInspectable var bottomLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var topLine: Bool = true { didSet{ drawLines() } }
    
    func drawLines(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
            //UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0).CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        border.borderWidth = width
        layer.addSublayer(border)
    }
    
}

class UnderlinedButton: UIButton {
    
    @IBInspectable var leftLine: Bool = true { didSet{ drawLines() } }
    @IBInspectable var rightLine: Bool = true { didSet{ drawLines() } }
    @IBInspectable var bottomLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var topLine: Bool = true { didSet{ drawLines() } }
    
    func drawLines(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        border.borderWidth = width
        layer.addSublayer(border)
    }
    
}

class UnderlinedStackView: UIStackView {
    
    @IBInspectable var leftLine: Bool = true { didSet{ drawLines() } }
    @IBInspectable var rightLine: Bool = true { didSet{ drawLines() } }
    @IBInspectable var bottomLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var topLine: Bool = true { didSet{ drawLines() } }
    
    func drawLines(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        border.borderWidth = width
        layer.addSublayer(border)
    }
    
}

extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
}