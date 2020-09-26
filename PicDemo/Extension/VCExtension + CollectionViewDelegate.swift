//
//  VCExtension + CollectionViewDelegate.swift
//  PicDemo
//
//  Created by ko on 2020/9/24.
//  Copyright © 2020 SM. All rights reserved.
//

import Foundation
import UIKit
 

// MARK: - UICollectionViewDataSource DataSource
extension SecondViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoViewmodel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = self.photoViewmodel?.photos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! ItemCell
        
        cell.idLabel.text =  "\(data?.id ?? 0)"
        cell.titleLabel.text = data?.title
     
        self.photoViewmodel?.setImage(to: URL(string: (data?.thumbnailUrl)!)!, completionHanlder: { publisher in
            cell.subscriber =  publisher.assign(to: \.thumbnailImageView.image, on: cell)
        })
 
        
        return cell
    }
    
}
