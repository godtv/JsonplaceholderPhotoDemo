//
//  ItemCell.swift
//  PicDemo
//
//  Created by ko on 2020/9/22.
//  Copyright © 2020 SM. All rights reserved.
//

import UIKit
import Combine

class ItemCell: UICollectionViewCell {
    
    static let reuseId = "ExampleCodeCell"
    
    var idLabel : UILabel!
    var titleLabel: UILabel!
    var cellStackView: UIStackView!
    var thumbnailUrl : String!
    var thumbnailImageView: UIImageView!
    var subscriber: AnyCancellable?
    
    private func setupLabel(style: UIFont.TextStyle) -> UILabel {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byCharWrapping
        lbl.textAlignment = .center
        
        lbl.adjustsFontForContentSizeCategory = true
        
        let pointSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).pointSize
        lbl.font = UIFont.preferredFont(forTextStyle: style).withSize(pointSize)
        
        return lbl
    }
    
    private func setupStackView(input: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: input)
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let ctv = self.contentView
        let layoutMarginGuide = ctv.layoutMarginsGuide
        //title
        let titleLab = setupLabel(style: .headline)
        self.titleLabel = titleLab
        //id
        let idLab = setupLabel(style: .callout)
        self.idLabel = idLab
        //stackView
        let stackV = setupStackView(input: [idLab, titleLab])
        ctv.addSubview(stackV)
        //imageView
        let mainImage = UIImageView.init(frame: .zero)
        mainImage.contentMode = .scaleAspectFill
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.clipsToBounds = true
        mainImage.layer.masksToBounds = true
        self.thumbnailImageView = mainImage
 
        //config backgroundView
        self.backgroundView = mainImage
        
        NSLayoutConstraint.activate([
            
            mainImage.topAnchor.constraint(equalTo: ctv.topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: ctv.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: ctv.trailingAnchor),
            mainImage.bottomAnchor.constraint(equalTo: ctv.bottomAnchor),
            
            stackV.topAnchor.constraint(equalTo: layoutMarginGuide.topAnchor),
            stackV.leadingAnchor.constraint(equalTo: layoutMarginGuide.leadingAnchor),
            stackV.trailingAnchor.constraint(equalTo: layoutMarginGuide.trailingAnchor),
            stackV.bottomAnchor.constraint(equalTo: layoutMarginGuide.bottomAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleLabel.text = nil
        self.idLabel.text = nil
        self.thumbnailImageView.image = UIImage()
    }
    
}
 
