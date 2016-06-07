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


class UnderlinedLabel: UILabel {
    
    override var text: String! {
        
        didSet {
            // swift < 2. : let textRange = NSMakeRange(0, count(text))
            let textRange = NSMakeRange(0, text.characters.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.StyleSingle.rawValue, range: textRange)
            // Add other attributes if needed
            
            self.attributedText = attributedText
        }
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
    
    @IBInspectable
    var shadowColor: UIColor?{
        get{
            return layer.shadowColor != nil ? UIColor(CGColor: layer.shadowColor!) : nil
        }
        set{
            layer.backgroundColor = newValue?.CGColor
        }
    }

	@IBInspectable
	var makeCircular: Bool?{
	get {
	return nil
	}
	set {
	if let makeCircular = newValue where makeCircular{
	cornerRadius = min(bounds.width, bounds.height)/2.0
	}
        }
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

extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
}