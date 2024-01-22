//
//  GallarySeparator.swift
//  KICardGallary
//
//  Created by Иван Конищев on 19.01.2024.
//

import UIKit

open class GallarySeparator: UIView {
    
    private var type: SeparatorType = .plain
    private var separatorColor: UIColor = .clear
    private var views: [UIView] = [] // subview сепаратора
    private var width: CGFloat = 10 // ширина сепаратора
    private var subviewSeparatorHeight: CGFloat { // высота subview сепаратора
        return width
    }
    
    private var height: CGFloat = 0
    private lazy var centered: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()
    
    // растояние между subview сепаратора
    private var bindingSeparatorheight: CGFloat {
        return (height - (4 * width)) / 4 / 2
    }
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(height: CGFloat ,type: SeparatorType = .plain, color: UIColor = .clear, separatorWidth: CGFloat = 10) {
        self.init(frame: .zero)
        self.type = type
        self.separatorColor = color
        self.backgroundColor = color
        self.width = separatorWidth
        self.height = height
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isHide() {
        self.isHidden = true
    }
    
    func isVisible() {
        self.isHidden = false
    }
    
    private func setupView() {
        guard type != .plain else {return}
        
        for _ in 0...3 {
            self.addSubview(getDelimeter())
        }
        
        switch type {
        case .plain:
            break
        case .center:
            setConstraints(width * 3)
        }
    }
    
    
    private func setConstraints(_ width: CGFloat) {
        
        NSLayoutConstraint.activate([
            centered.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            centered.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            centered.heightAnchor.constraint(equalToConstant: 0.1),
            centered.widthAnchor.constraint(equalToConstant: 0.1),
            views[0].widthAnchor.constraint(equalToConstant: width),
            views[1].widthAnchor.constraint(equalToConstant: width),
            views[2].widthAnchor.constraint(equalToConstant: width),
            views[3].widthAnchor.constraint(equalToConstant: width),
            
            views[0].heightAnchor.constraint(equalToConstant: self.subviewSeparatorHeight),
            views[1].heightAnchor.constraint(equalToConstant: self.subviewSeparatorHeight),
            views[2].heightAnchor.constraint(equalToConstant: self.subviewSeparatorHeight),
            views[3].heightAnchor.constraint(equalToConstant: self.subviewSeparatorHeight),
            
            views[1].topAnchor.constraint(equalTo: views[0].bottomAnchor, constant: bindingSeparatorheight),
            views[1].bottomAnchor.constraint(equalTo: centered.topAnchor, constant: -(bindingSeparatorheight / 2)),
            views[2].topAnchor.constraint(equalTo: centered.bottomAnchor, constant: (bindingSeparatorheight / 2)),
            views[3].topAnchor.constraint(equalTo: views[2].bottomAnchor, constant: bindingSeparatorheight),
        ])
        for bindView in views {
            switch type {
            case .center:
                bindView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            case .plain:
                break
            }
        }
        
    }
    
    private func getDelimeter() -> UIView {
        let view = UIView()
        view.backgroundColor = separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = self.width / 2
        self.views.append(view)
        return view
    }
    
}
