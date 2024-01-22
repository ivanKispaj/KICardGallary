//
//  GallarySubview.swift
//  KICardGallary
//
//  Created by Иван Конищев on 11.01.2024.
//

import UIKit

// MARK: - The type of view for activating constraints
public enum ConstraintTypeActivate {
    case side,center
}

// MARK: - GalleryView
open class GallarySubview: UIView {
    
    // MARK: -  View
    
    // Image view for gallary view
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.sizeToFit()
        return imgView
    }()
    
    // MARK: -  Constraints for activation
    public var centerXAnchorConstraint: NSLayoutConstraint?
    public var heightAnchorConstraint: NSLayoutConstraint?
    public var widthAnchorContstraint: NSLayoutConstraint?
    public var leadingAnchorContsraint: NSLayoutConstraint?
    public var trailingAnchorConstraint: NSLayoutConstraint?
    
    // Insets for image
    public lazy var imgEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
   // public lazy var imgEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    
    // Set image
    public func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    // Set background color
    public func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    // Set corner radius
    public func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    // Hide this view
    public func ishide() {
        self.isHidden = true
    }
    
    // Set visible this view
    public func isVisible() {
        self.isHidden = false
    }
    
    // Activate constraints
    public func activateConstraint(to type: ConstraintTypeActivate) {
        switch type {
        case .center:
            centerXAnchorConstraint?.isActive = true
        default:
            break
        }
        heightAnchorConstraint?.isActive = true
        widthAnchorContstraint?.isActive = true
        leadingAnchorContsraint?.isActive = true
        trailingAnchorConstraint?.isActive = true
    }
    
    // MARK: - private methods
    
    private func setupView() {
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: imgEdgeInsets.left),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: imgEdgeInsets.top),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -imgEdgeInsets.right),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -imgEdgeInsets.bottom)
        ])
    }
}
