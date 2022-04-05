//
//  PasswordTextField.swift
//  Team_India
//
//  Created by Josh Quaid on 3/25/22.
//

import UIKit

class PasswordTextField: UITextField {

    private let rightAccessoryButton: UIButton = UIButton(frame: .zero)
    
    @IBInspectable private var rightViewImage: UIImage? {
        didSet {
            rightAccessoryButton.setImage(rightViewImage, for: .normal)
            rightViewMode = rightViewImage != nil ? .always : .never
        }
    }
    
    @IBInspectable private var rightViewPadding: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable private var centerInset: CGPoint = .zero {
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
    
    func setUpPasswordField() {
        rightView = rightAccessoryButton
        rightViewMode = .never
        //visButton.addTarget(self, action: #selector(self.togglePassVis), for: .touchUpInside)
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


}
