# KICardGallary swift package


    A package that provides a gallery in the form of cards.
    The selected image is enlarged in the center relative to the others.
## Objects
      GallaryView - The main gallery containing the cards.
      Initialized in two possible ways
      1. init(data gallaryData: GallaryData) 

      2. init(images: [UIImage],
                 gallaryWidth: CGFloat,
                 gallaryHeight: CGFloat = 220,
                 separatorColor: UIColor = .clear,
                 separatorType: SeparatorType = .plain) 
                 
           - images - array UIImage
           - gallaryWidth - Gallery width or screen width
           - gallaryHeight - Gallary height
           - separatorColor - color of separator
           - separatorType - type separator ( .book or .plain)

Methods:
        setSelectedColor(UIColor) - Sets the color of the selected center image
        setUnselectedColor(UIColor) - Sets the color of the side unselected images
        setCurrentActiveImage(index: image index) - Sets the currently selected image


## struct GallaryData

    GallaryData(images: self.images,
                    width: self.view.frame.width,
                    separatorType: .plain
                    height: gallaryHeight,
                    separatorColor: viewBackground)
    - images - array UIImage
    - width - Gallery width or screen width
    - gallaryHeight - Gallary height
    - separatorColor - color of separator

## Usage:
    Add a package via SwiftPM - https://github.com/ivanKispaj/KICardGallary.git
    import KICardGallary


```Swift

import UIKit
import KICardGallary

class ViewController: UIViewController {

    lazy var button: UIButton = {
       let button = UIButton()
        button.setTitle("Tapp my", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(tupped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Background for this view
    let viewBackground: UIColor = UIColor(named: "background") ?? .black
    
    // images array
    let images: [UIImage?] = [UIImage(systemName: "airplane"), UIImage(systemName: "figure.wave"), UIImage(systemName: "car"), UIImage(systemName: "car.2"), UIImage(systemName: "globe.central.south.asia"), UIImage(systemName: "wave.3.left"), UIImage(systemName: "digitalcrown.arrow.counterclockwise.fill")]
    
    // gallary height
    let gallaryHeight: CGFloat = 220
    
    // gallary
    private lazy var gallary: GallaryView = {
        let gallaryData = GallaryData(images: self.images, width: self.view.frame.width,
                                      height: gallaryHeight,
                                      separatorColor: viewBackground)
        
        let view = GallaryView(data: gallaryData)
        view.setSelectedColor(.systemGray6)
        view.setUnselectedColor(.systemGray)
        view.setCurrentActiveImage(index: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    @objc func tupped() {
        print(self.gallary.selectedIndex)
    }
    // MARK: - Set constraints
    private func setupView() {
        self.view.addSubview(gallary)
        self.view.backgroundColor = viewBackground
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            gallary.heightAnchor.constraint(equalToConstant: gallaryHeight),
            gallary.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            gallary.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            gallary.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.view.bottomAnchor.constraint(greaterThanOrEqualTo: gallary.bottomAnchor),
            self.view.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 50),
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
```

### midle gallary with plain separator
https://github.com/ivanKispaj/KICardGallary/assets/91827767/c98a1c9a-a3b1-4a13-9ffc-135f2da8df97

### large gallary with plain separator
https://github.com/ivanKispaj/KICardGallary/assets/91827767/12925938-5687-442b-b6c7-cb6ae94c72ed


### small gallary with book separator
https://github.com/ivanKispaj/KICardGallary/assets/91827767/d8d363a8-d08b-46f8-8d0c-5e0422dca0b5

### midle gallary with book separator
https://github.com/ivanKispaj/KICardGallary/assets/91827767/1fe698dd-2476-4175-8429-fd5474e27460

### large gallary with book separator
https://github.com/ivanKispaj/KICardGallary/assets/91827767/c391084a-aecf-4d8e-9a9c-bb48c1c5b5a3




