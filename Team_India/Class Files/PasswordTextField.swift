//
//  PasswordTextField.swift
//  Team_India
//
//  Created by Josh Quaid on 3/25/22.
//

import UIKit

class PasswordTextField: UITextField {
    // Set the pallette rendering mode for symbol images (the eye for the password fields)
    private let config = UIImage.SymbolConfiguration(paletteColors: [.systemGray])
    private let eyeImage = UIImage(systemName: "eye")
    private let eyeSlashImage = UIImage(systemName: "eye.slash")

    private let rightAccessoryButton: UIButton = UIButton(frame: .zero)
    
    @IBInspectable private var rightViewImage: UIImage? {
        didSet {
            rightAccessoryButton.setImage(rightViewImage, for: .normal)
            rightViewMode = rightViewImage != nil ? .always : .never
        }
    }
    
    // Set the padding for the rightView so the symbol doesn't run up on the side of the field
        // Allow adjustment in the Interface Builder
    @IBInspectable private var rightViewPadding: CGFloat = 6 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // Set the inset for the text to begin displaying rather than running up on the side of the field.
    @IBInspectable private var centerInset: CGPoint = CGPoint(x: 6, y: 0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setUpPasswordField()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpPasswordField()
    }
    
    // MARK: - Funcs
    
    func setUpPasswordField() {
        self.isSecureTextEntry = false
        self.keyboardType = .default
        rightViewImage = eyeSlashImage?.applyingSymbolConfiguration(config)
        rightAccessoryButton.setImage(rightViewImage, for: .normal)
        rightView = rightAccessoryButton
        rightViewMode = .always
        rightAccessoryButton.addTarget(self, action: #selector(self.togglePassVis), for: .touchUpInside)
        
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        insetTextRect(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        insetTextRect(forBounds: bounds)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightViewRect = super.rightViewRect(forBounds: bounds)
        rightViewRect.origin.x -= rightViewPadding
        return rightViewRect
    }
    
    private func insetTextRect(forBounds bounds: CGRect) -> CGRect {
        var insetBounds = bounds.insetBy(dx: centerInset.x, dy: centerInset.y)
        insetBounds.size.width -= rightViewPadding + rightAccessoryButton.bounds.width
        return insetBounds
    }

    @IBAction func togglePassVis() {
        self.isSecureTextEntry.toggle()
        // Set the image to the opposite of what is displayed for the visibilityButton
        if !self.isSecureTextEntry {
            rightAccessoryButton.setImage(eyeImage?.applyingSymbolConfiguration(config), for: .normal)
        } else {
            if let existingPassText = self.text {
                self.deleteBackward()
                if let passwordTextRange = self.textRange(from: self.beginningOfDocument, to: self.endOfDocument) {
                self.replace(passwordTextRange, withText: existingPassText)
                }
            }
            
            // Set the rightAccessoryButton to the eye.slash image
            rightAccessoryButton.setImage(eyeSlashImage?.applyingSymbolConfiguration(config), for: .normal)
            
            if let existingSelectedRange = self.selectedTextRange {
                self.selectedTextRange = nil
                self.selectedTextRange = existingSelectedRange
            }
        }
    }
    
}
