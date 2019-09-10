//
//  ExpFloatingLabelTextField.swift
//  expressPay
//
//  Created by KWEI HESSE on 2016-11-20.
//  Copyright © 2016 expressPay. All rights reserved.
//

import UIKit

class ExpFloatingLabelTextField: SkyFloatingLabelTextField {

    var errorLabel:UILabel!
    @IBInspectable
    var rightMargin : CGFloat = 0
    var leftMargin : CGFloat = 0
    // MARK: Colors
    
    private var cachedTextColor:UIColor?
    
    /// A UIColor value that determines the text color of the editable text
    @IBInspectable
    override public var textColor:UIColor? {
        set {
            self.cachedTextColor = newValue
            self.updateControl(animated: false)
        }
        get {
            return cachedTextColor
        }
    }
     
    //MARK: - Properties
    public var errorMsg:String? {
        didSet {
            self.updateControl(animated: true)
        }
    }
    
    private var _highlighted = false
    
    /// A Boolean value that determines whether the receiver is highlighted. When changing this value, highlighting will be done with animation
    override public var isHighlighted:Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            self.updateTitleColor()
            self.updateLineView()
            self.updateErrorLabel()
        }
    }
    
    override public func isTitleVisible() -> Bool {
        return self.hasText || self.hasErrorMsg || self.isEditing
    }
    
    /// A Boolean value that determines whether the receiver has an error message.
    public var hasErrorMsg:Bool {
        get {
            return self.errorMsg != nil && self.errorMsg != ""
        }
    }
    
    
    // MARK: - Initializers
    
    /**
     Initializes the control
     - parameter frame the frame of the control
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.init_ExpFloatingLabelTextField()
    }
    
    /**
     Intialzies the control by deserializing it
     - parameter coder the object to deserialize the control from
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.init_ExpFloatingLabelTextField()
    }
    
    private final func init_ExpFloatingLabelTextField() {
       createErrorLabel()
    }
    
    public override func editingChanged() {
        updateControl(animated: true)
    }
    
    // MARK: create components
    private func createErrorLabel() {
        let errorLabel = UILabel()
        errorLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        errorLabel.font = UIFont(name:"GothamBook", size: 13)
        errorLabel.alpha = 1.0
        errorLabel.textColor = UIColor.red
        self.addSubview(errorLabel)
        self.errorLabel = errorLabel
    }
    
    // MARK: Responder handling
    
    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
     */
    override public func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.updateControl(animated: true)
        return result
    }
    
    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    override public func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.updateControl(animated: true)
        return result
    }
    
    // MARK: - View updates

    private func updateControl(animated:Bool = false) {
        self.updateColors()
        self.updateLineView()
        self.updateErrorLabel(animated: animated)
        self.updateTitleLabel(animated: animated)
    }
    
    private func updateLineView() {
        if let lineView = self.lineView {
            lineView.frame = self.lineViewRectForBounds(bounds: self.bounds, editing: self.editingOrSelected)
        }
        self.updateLineColor()
    }
    
    // MARK: - Color updates

    override func updateColors() {
        self.updateLineColor()
        self.updateTitleColor()
        self.updateTextColor()
    }
    
    private func updateLineColor() {
        if self.hasErrorMsg {
            self.lineView.backgroundColor = self.errorColor
        } else {
            self.lineView.backgroundColor = self.editingOrSelected ? self.selectedLineColor : self.lineColor
        }
    }
    
    private func updateTitleColor() {
        if self.editingOrSelected || self.isHighlighted {
            self.titleLabel.textColor = self.selectedTitleColor
        } else {
            self.titleLabel.textColor = self.titleColor
        }
    }
    
    private func updateTextColor() {
        //self.textColor = self.cachedTextColor

    }
    
    // MARK: - Title handling
    
    private func updateTitleLabel(animated:Bool = false) {
        
        var titleText:String? = nil
        if self.editingOrSelected {
            titleText = self.selectedTitleOrTitlePlaceholder()
            if titleText == nil {
                titleText = self.titleOrPlaceholder()
            }
        } else {
            titleText = self.titleOrPlaceholder()
        }
        
        
        self.titleLabel.text = titleText
        
        self.updateTitleVisibility(animated: animated)
    }
    
    private func updateTitleVisibility(animated:Bool = false, completion: (()->())? = nil) {
        let alpha:CGFloat = self.isTitleVisible() ? 1.0 : 0.0
        let frame:CGRect = self.titleLabelRectForBounds(bounds: self.bounds, editing: self.isTitleVisible())
        let updateBlock = { () -> Void in
            self.titleLabel.alpha = alpha
            self.titleLabel.frame = frame
        }
        if animated {
            let animationOptions:UIView.AnimationOptions = .curveEaseOut;
            let duration = self.isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
            
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: { _ in
                completion?()
            })
        } else {
            updateBlock()
            completion?()
        }
    }
    
    
    // MARK: - Error handling
    
    private func updateErrorLabel(animated:Bool = false) {
        
        var titleText:String? = nil
        if self.hasErrorMsg {
            titleText = errorMsg!
        }
        self.errorLabel.text = titleText
        
        updateErrorLabelVisibility(animated: animated)
    }
    
    private func updateErrorLabelVisibility(animated:Bool = false, completion: (()->())? = nil) {
        let alpha:CGFloat = self.hasErrorMsg ? 1.0 : 0.0
        let frame:CGRect = self.errorLabelRectForBounds(bounds: self.bounds, editing: self.hasErrorMsg)
        let updateBlock = { () -> Void in
            self.errorLabel.alpha = alpha
            self.errorLabel.frame = frame
        }
        if animated {
            let animationOptions:UIView.AnimationOptions = .curveEaseOut;
            let duration = self.hasErrorMsg ? titleFadeInDuration : titleFadeOutDuration
            
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: { _ in
                completion?()
            })
        } else {
            updateBlock()
            completion?()
        }
    }
    
    
    // MARK: - UITextField text/placeholder positioning overrides
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        _=super.textRect(forBounds: bounds)
        let titleHeight = self.titleHeight()
        let lineHeight = self.selectedLineHeight
        let errorHeight = self.errorHeight
        let rect = CGRect(x:leftMargin, y:titleHeight, width:bounds.size.width - rightMargin - leftMargin, height:bounds.size.height - titleHeight - lineHeight-errorHeight - errorLabelTopMargin)
        return rect
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let titleHeight = self.titleHeight()
        let lineHeight = self.selectedLineHeight
        let errorHeight = self.errorHeight

        let rect = CGRect(x:leftMargin, y:titleHeight, width:bounds.size.width - rightMargin - leftMargin, height:bounds.size.height - titleHeight - lineHeight - errorHeight - errorLabelTopMargin)
        return rect
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let titleHeight = self.titleHeight()
        let lineHeight = self.selectedLineHeight
        let errorHeight = self.errorHeight

        let rect = CGRect(x:leftMargin, y:titleHeight, width:bounds.size.width - rightMargin - leftMargin, height:bounds.size.height - titleHeight - lineHeight - errorHeight - errorLabelTopMargin)
        return rect
    }
    
    
    // MARK: - Positioning Overrides
    public override func lineViewRectForBounds(bounds:CGRect, editing:Bool) -> CGRect {
        let lineHeight:CGFloat = editing ? CGFloat(self.selectedLineHeight) : CGFloat(self.lineHeight)
        let errorHeight = self.errorHeight

        return CGRect(x:CGFloat(0), y:bounds.size.height - lineHeight - errorHeight - errorLabelTopMargin, width:bounds.size.width, height:lineHeight)
    }
    
    public func errorLabelRectForBounds(bounds:CGRect, editing:Bool) -> CGRect {
        let errorHeight = self.errorHeight
       
        return CGRect(x:0, y:bounds.size.height - errorHeight , width:bounds.size.width, height:errorHeight )
    }
    
    public var errorLabelTopMargin:CGFloat = 5.0

   /* public func errorHeight() -> CGFloat {
       /* if let errorLabel = self.errorLabel,
            let font = errorLabel.font {
            return font.lineHeight
        }*/
        return 11.0
    }*/
    
    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.errorLabel.frame = self.errorLabelRectForBounds(bounds: self.bounds, editing:true)
    }
    
    /**
     Calculate the content size for auto layout
     
     - returns: the content size to be used for auto layout
     */
    override public var intrinsicContentSize: CGSize {
        get {
            return CGSize(width:self.bounds.size.width, height:self.titleHeight() + self.textHeight()+self.errorHeight)
        }
    }
    
    
    
    // MARK: - Helpers
    
    private func titleOrPlaceholder() -> String? {
        if let title = self.title ?? self.placeholder {
            return title
        }
        return nil
    }
    
    private func selectedTitleOrTitlePlaceholder() -> String? {
        if let title = self.selectedTitle ?? self.title ?? self.placeholder {
            return title
        }
        return nil
    }
    

}
