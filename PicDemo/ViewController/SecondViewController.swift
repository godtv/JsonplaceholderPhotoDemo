//
//  SecondViewController.swift
//  PicDemo
//
//  Created by ko on 2020/9/22.
//  Copyright © 2020 SM. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var flowLayout = UICollectionViewFlowLayout()
    var screen = UIScreen.main.bounds
    var photoViewmodel: PhotoViewModel?
    
    lazy var collectionView: UICollectionView! = {
        self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: self.flowLayout)
        view.dataSource = self
        return view
    }()
    
    var cellID = "cellid"
    var safeLayoutGuide:UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: self.cellID)

        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)

         collectionView.collectionViewLayout = createCompositionalLayout()
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
 
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout

    }
    
}


 
