
//  GallaryData.swift
//  KICardGallary
//
//  Created by Иван Конищев on 21.01.2024.
//

import UIKit

public struct GallaryData {
    private var width: CGFloat // ширина галлереи
    private var height: CGFloat = 220 // высота галлереи
    var separatorColor: UIColor = .clear
   // private var separatorWidth: CGFloat = 10
    private var separatorType: SeparatorType = .plain
    
   public var images: [UIImage?] = []
    
    // Returns the width of the central view
    public var currentViewWidth: CGFloat {
        // The width is less than the height by 20%
        let width = height * 0.8
        if width > self.width {
            return self.width - getSeparatorWidth() * 2 - 20
        }
        return height * 0.8
    }
    
    // Returns the height of the central view
    public var currentViewHeight: CGFloat {
        // Сurrent view equal gallary height
        return self.height
    }
    
    // Returns the width of the side view
    public var sideViewWidth: CGFloat {
        // The side views are 25% smaller in width than the main height
        return self.currentViewWidth * 0.75
    }
    
    // Returns the height of the side view
    public var sideViewHeight: CGFloat {
        // The height of the side views is less than the main ones by 15%
        return height * 0.85
    }
    
    // MARK: - init
    init() {
        self.width = 300
    }
    
    public init(width: CGFloat) {
        self.width = width
    }
    
    public init(images: [UIImage?], width: CGFloat,
         height: CGFloat = 220,
         separatorColor: UIColor = .clear,
         mainImgWidth: CGFloat = 3) {
        self.width = width
        self.height = height
        self.separatorColor = separatorColor
        self.images = images
    }
    
    
    // Returns the width of the gallery
    public func getWidth() -> CGFloat {
        return width
    }
    
    // Returns the height of the gallery
    public func getHeight() -> CGFloat {
        return height
    }
    
    // Returns the color of the separator
    public func getSeparatorColor() -> UIColor {
        return separatorColor
    }
    
    // Returns the width of the separator
    public func getSeparatorWidth() -> CGFloat {
        return self.height * 0.046
    }
}
