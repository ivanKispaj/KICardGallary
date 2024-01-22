// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  GallaryView.swift
//  KICardGallary
//
//  Created by Иван Конищев on 19.01.2024.
//

import UIKit

open class GallaryView: UIView {
    
    // Basic data for the gallery
    private var gallaryData: GallaryData?
    
    // The currently selected image
    private var currentImgPath = 0
    
    // Colors for the selected and other images
    private var selectedColor: UIColor = .blue
    private var unselectedColor: UIColor = .blue.withAlphaComponent(0.5)
    
    // Image scrolling direction
    enum GallaryScrollDirection {
        case left, right
    }
    private var directionOf: GallaryScrollDirection!
    
    // Property animatior
    private var animator: UIViewPropertyAnimator? = nil
    
    
    // MARK: - Views
    
    // central selected view
    private lazy var currentImageView: GallarySubview = {
        let  view = GallarySubview()
        view.setBackgroundColor(selectedColor)
        view.setCornerRadius(15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    // all views are in order from left to right
    private var anyViews: [GallarySubview] = []
    
    // Index mask to display
    private var indexes: [Int?] = []
    
    // The calculated property returns the required number of separators
    private lazy var separators: [GallarySeparator] = {
        guard let data = self.gallaryData else {return []}
        var separators: [GallarySeparator] = []
        for _ in 0...anyViews.count - 2 {
            separators.append(getSeparator(data))
        }
        return separators
    }()
    
    // The calculated property returns the index of the central image of the gallery
    private var centerindex: Int {
        return Int(Double(anyViews.count) / 2.rounded(.down))
    }
    
    // MARK: - initializators
    
    // Default frame init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    // Init with GallaryData
    convenience init(data gallaryData: GallaryData) {
        self.init(frame: .zero)
        self.gallaryData = gallaryData
        guard gallaryData.images.count > 0 else {return}
        setupViews()
    }
    
    // Init with all data
    convenience init(images: [UIImage],
                     gallaryWidth: CGFloat,
                     gallaryHeight: CGFloat = 220,
                     separatorColor: UIColor = .clear,
                     separatorType: SeparatorType = .plain) {
        self.init(frame: .zero)
        
        if #available(iOS 13, *) {
            self.selectedColor = UIColor(named: "select") ?? UIColor.systemGray6
            self.unselectedColor = UIColor(named: "unselect") ?? UIColor.systemGray
        } else {
            self.selectedColor = UIColor(named: "select") ?? UIColor.gray
            self.unselectedColor = UIColor(named: "unselect") ?? UIColor.gray.withAlphaComponent(0.5)
        }
        
        guard images.count > 0 && gallaryWidth > gallaryHeight else {return}
        self.gallaryData = GallaryData(images: images, width: gallaryWidth, separatorColor: separatorColor)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Views
    
    private func setupViews() {
        
        guard let data = self.gallaryData else {return}
        
        /*
         We get the number of additional views in total with currentView should be odd!
         One picture is central and the rest are evenly spaced on the sides
         */

        var countAnyViews: Int = 0
        if data.currentViewWidth > (data.getWidth() / 2) {
            countAnyViews = 4
        } else {
            countAnyViews = Int((data.getWidth() / data.currentViewWidth).rounded(.up) + 1)
            if countAnyViews % 2 != 0 {
                countAnyViews += 1
            }
        }

        
        // Adding additional views
        for _ in 0...countAnyViews - 1 {
            let view = GallarySubview()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setBackgroundColor(unselectedColor)
            view.setCornerRadius(15)
            anyViews.append(view)
            self.addSubview(view)
        }
        
        // Adding a central view
        self.addSubview(currentImageView)
        anyViews.insert(currentImageView, at: countAnyViews / 2)
        
        // Adding separators to the view
        for separator in separators {
            self.addSubview(separator)
        }
        
        // Adding the pan gesture recognizer
        let pan = UIPanGestureRecognizer(target: self, action: #selector(scrollingGallary))
        self.addGestureRecognizer(pan)
        
        // Setting constants for all views
        setupConstraint(data)
    }
    
    // MARK: -  Setting constants for all views
    private func setupConstraint(_ data: GallaryData) {
        // Constraints for side invisible views!
        NSLayoutConstraint.activate([
            anyViews[0].centerYAnchor.constraint(equalTo: self.centerYAnchor),
            anyViews[0].trailingAnchor.constraint(equalTo: separators[0].leadingAnchor),
            anyViews[0].widthAnchor.constraint(equalToConstant: data.sideViewWidth),
            anyViews[0].heightAnchor.constraint(equalToConstant: data.sideViewHeight),
            
            anyViews[anyViews.count - 1].centerYAnchor.constraint(equalTo: self.centerYAnchor),
            anyViews[anyViews.count - 1].leadingAnchor.constraint(equalTo: separators[separators.count - 1].trailingAnchor),
            anyViews[anyViews.count - 1].widthAnchor.constraint(equalToConstant: data.sideViewWidth),
            anyViews[anyViews.count - 1].heightAnchor.constraint(equalToConstant: data.sideViewHeight),
            
            separators[separators.count - 1].centerYAnchor.constraint(equalTo: self.centerYAnchor),
            separators[separators.count - 1].widthAnchor.constraint(equalToConstant: data.getSeparatorWidth()),
            separators[separators.count - 1].heightAnchor.constraint(equalToConstant: data.getHeight()),
        ])
        
        // Properties for setting the size of the view and its type
        var width: CGFloat = data.sideViewWidth
        var height: CGFloat = data.sideViewHeight
        var typeView: ConstraintTypeActivate = .side
        
        // Installing and activating constants for visible views
        for index in 1...anyViews.count - 2 {
            
            if index == centerindex {
                width = data.currentViewWidth
                height = data.currentViewHeight
                typeView = .center
            } else {
                width = data.sideViewWidth
                height = data.sideViewHeight
                typeView = .side
            }
            
            self.anyViews[index].centerXAnchorConstraint = self.anyViews[index].centerXAnchor.constraint(equalTo: self.centerXAnchor)
            self.anyViews[index].widthAnchorContstraint = self.anyViews[index].widthAnchor.constraint(equalToConstant: width)
            self.anyViews[index].heightAnchorConstraint = self.anyViews[index].heightAnchor.constraint(equalToConstant: height)
            self.anyViews[index].leadingAnchorContsraint = self.anyViews[index].leadingAnchor.constraint(equalTo: separators[index - 1].trailingAnchor)
            self.anyViews[index].trailingAnchorConstraint = self.anyViews[index].trailingAnchor.constraint(equalTo: separators[index].leadingAnchor)
            
            anyViews[index].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            separators[index - 1].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            separators[index - 1].widthAnchor.constraint(equalToConstant: data.getSeparatorWidth()).isActive = true
            separators[index - 1].heightAnchor.constraint(equalToConstant: data.getHeight()).isActive = true
            
            self.anyViews[index].activateConstraint(to: typeView)
        }
        
        // Filling in the index mask to display the view
        fillIndexess(data)
        
        // setting up images and view visibility/invisibility
        setImageToGallary(data)
    }
    
    // MARK: - Filling in the index mask to display the view
    private func fillIndexess(_ data: GallaryData) {
        self.indexes = [] // обнуляем массив индексов
        
        if currentImgPath > data.images.count {
            if currentImgPath < 0 {
                currentImgPath += 1
                
            } else {
                currentImgPath -= 1
                
            }
        }
        
        var current = currentImgPath
        var center = self.centerindex
        
        for _ in self.centerindex + 1...anyViews.count {
            if current < data.images.count {
                indexes.append(current)
            } else {
                indexes.append(nil)
            }
            current += 1
        }
        
        current = currentImgPath - 1
        
        while (center > 0) {
            if current >= 0 {
                indexes.insert(current, at: 0)
            } else {
                indexes.insert(nil, at: 0)
            }
            current -= 1
            center -= 1
        }
    }
    
    // MARK: - setting up images and view visibility/invisibility
    
    private func setImageToGallary(_ data: GallaryData) {
        if data.images.count > 0 {
            for (index,value) in indexes.enumerated() {
                if let valueIndex = value {
                    if (index + 1 < anyViews.count) {
                        if (indexes[index + 1] != nil) {
                            separators[index].isVisible()
                        } else {
                            if index < separators.count {
                                separators[index].isHide()
                            }
                        }
                    }
                    anyViews[index].setImage(data.images[valueIndex])
                    anyViews[index].isVisible()
                    
                } else {
                    anyViews[index].ishide()
                    if index < separators.count {
                        separators[index].isHide()
                    }
                }
            }
        }
    }
    
    // MARK: - Animate
    
    private func animateRightScroll() {
        self.anyViews[self.centerindex].setBackgroundColor(self.unselectedColor)
        self.anyViews[self.centerindex - 1].setBackgroundColor(self.selectedColor)
        guard let data = self.gallaryData else {return}
        self.anyViews[centerindex].setBackgroundColor(unselectedColor)
        self.anyViews[centerindex].widthAnchorContstraint?.constant = data.sideViewWidth
        self.anyViews[centerindex].heightAnchorConstraint?.constant = data.sideViewHeight
        self.anyViews[centerindex].centerXAnchorConstraint?.isActive = false
        
        self.anyViews[centerindex - 1].widthAnchorContstraint?.constant = data.currentViewWidth
        self.anyViews[centerindex - 1].heightAnchorConstraint?.constant = data.currentViewHeight
        self.anyViews[centerindex - 1].centerXAnchorConstraint?.isActive = true
        self.layoutIfNeeded()
        
    }
    
    private func abortRightAnimate(isFinishAnimate: Bool) {
        guard let data = self.gallaryData else {return}
        
        if isFinishAnimate {
            fillIndexess(data)
            DispatchQueue.main.async {
                self.setImageToGallary(data)
                self.anyViews[self.centerindex].setBackgroundColor(self.selectedColor)
                self.anyViews[self.centerindex - 1].setBackgroundColor(self.unselectedColor)
            }
        }
        
        DispatchQueue.main.async {
            self.anyViews[self.centerindex].widthAnchorContstraint?.constant = data.currentViewWidth
            self.anyViews[self.centerindex].heightAnchorConstraint?.constant = data.currentViewHeight
            self.anyViews[self.centerindex - 1].centerXAnchorConstraint?.isActive = false
            self.anyViews[self.centerindex].centerXAnchorConstraint?.isActive = true
            self.anyViews[self.centerindex - 1].widthAnchorContstraint?.constant = data.sideViewWidth
            self.anyViews[self.centerindex - 1].heightAnchorConstraint?.constant = data.sideViewHeight
            self.layoutIfNeeded()
        }
    }
    
    private func animateLeftScroll() {
        guard let data = self.gallaryData else {return}
        self.anyViews[self.centerindex].setBackgroundColor(self.unselectedColor)
        self.anyViews[self.centerindex + 1].setBackgroundColor(self.selectedColor)
        self.anyViews[centerindex].setBackgroundColor(unselectedColor)
        self.anyViews[centerindex].widthAnchorContstraint?.constant = data.sideViewWidth
        self.anyViews[centerindex].heightAnchorConstraint?.constant = data.sideViewHeight
        self.anyViews[centerindex].centerXAnchorConstraint?.isActive = false
        
        self.anyViews[centerindex + 1].widthAnchorContstraint?.constant = data.currentViewWidth
        self.anyViews[centerindex + 1].heightAnchorConstraint?.constant = data.currentViewHeight
        self.anyViews[centerindex + 1].centerXAnchorConstraint?.isActive = true
        self.layoutIfNeeded()
    }
    
    private func abortLeftAnimate(isFinishAnimate: Bool) {
        guard let data = self.gallaryData else {return}
        if isFinishAnimate {
            fillIndexess(data)
            DispatchQueue.main.async {
                self.setImageToGallary(data)
                self.anyViews[self.centerindex].setBackgroundColor(self.selectedColor)
                self.anyViews[self.centerindex + 1].setBackgroundColor(self.unselectedColor)
            }
        }
        DispatchQueue.main.async {
            self.anyViews[self.centerindex].widthAnchorContstraint?.constant = data.currentViewWidth
            self.anyViews[self.centerindex].heightAnchorConstraint?.constant = data.currentViewHeight
            self.anyViews[self.centerindex + 1].centerXAnchorConstraint?.isActive = false
            self.anyViews[self.centerindex].centerXAnchorConstraint?.isActive = true
            self.anyViews[self.centerindex + 1].widthAnchorContstraint?.constant = data.sideViewWidth
            self.anyViews[self.centerindex + 1].heightAnchorConstraint?.constant = data.sideViewHeight
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Scrolling through the gallery
    
    @objc private func scrollingGallary(_ position: UIPanGestureRecognizer) {
        
        // Gallery data
        guard let data = self.gallaryData else {return}
        
        switch position.state {
            
        case .possible:
            break
        case .began:
            
            // Setting the direction of movement along the X axis!
            let positionX = position.velocity(in: self.currentImageView).x
            
            if positionX > 0 {
                self.directionOf = .right
            } else {
                self.directionOf = .left
            }
            
            
            if self.directionOf == .left {
                // MARK: - Start left-scrolling animation
                // setup next image path
                self.currentImgPath += 1
                
                // Install and run the animation
                self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                    self.animateLeftScroll()
                })
                
                // Processing the completion status of the animation interruption
                animator?.addCompletion { [self] position in
                    switch position {
                    case .end:
                        self.abortLeftAnimate(isFinishAnimate: true)
                    default:
                        self.abortLeftAnimate(isFinishAnimate: false)
                    }
                }
            } else if self.directionOf == .right {
                // MARK: - Start animation when scrolling right
                
                // setup next image path
                self.currentImgPath -= 1
                
                self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                    self.animateRightScroll()
                })
                
                animator?.addCompletion { [self] position in
                    switch position {
                    case .end:
                        self.abortRightAnimate(isFinishAnimate: true)
                    default:
                        self.abortRightAnimate(isFinishAnimate: false)
                    }
                }
            }
        case .changed:
            // MARK: - fractionComplete settings
            
            /*
             Affects the scrolling speed, the higher the value, the slower the scrolling
             */
            var percent = position.translation(in: self.currentImageView.superview).x
            
            if animator != nil {
                if percent < 0 {
                    percent.negate()
                } else {
                    if self.directionOf != .right {
                      //  break
                    }
                }
                percent /= 400
                self.animator?.fractionComplete =  min(1, max(0, percent))
            }
            
        case .ended:
            // MARK: - Completing the animation
            switch self.directionOf {
                
            case .left:
                if currentImgPath < data.images.count {
                    if animator!.fractionComplete > 0.4 {
                        completeAnimation(false)
                    } else {
                        self.currentImgPath -= 1
                        self.completeAnimation(true)
                    }
                } else {
                    self.currentImgPath -= 1
                    completeAnimation(true)
                }
            case .right:
                if currentImgPath >= 0 {
                    if animator!.fractionComplete > 0.4 {
                        completeAnimation(false)
                    } else {
                        self.currentImgPath += 1
                        self.completeAnimation(true)
                    }
                } else {
                    // reversed animation если достигли левого края
                    self.currentImgPath += 1
                    completeAnimation(true)
                }
            case .none:
                break
            }
            
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
    // Setting the final animation: finish or return
    private func completeAnimation(_ isReversed: Bool) {
        if isReversed {
            self.animator?.isReversed = true
        }
        self.animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }
    
    // Returns the gallery separator
    private func getSeparator(_ data: GallaryData) -> GallarySeparator {
        let separator = GallarySeparator(height: data.getHeight(), type: .center, color: data.getSeparatorColor(), separatorWidth: data.getSeparatorWidth())
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
}
