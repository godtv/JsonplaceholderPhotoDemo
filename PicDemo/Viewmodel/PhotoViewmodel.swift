//
//  PhotoViewmodel.swift
//  PicDemo
//
//  Created by ko on 2020/9/24.
//  Copyright © 2020 SM. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Combine

public typealias PublishHandler = (_ publisher: AnyPublisher<UIImage?, Never>) -> Void

class PhotoViewModel
{
    var photos = [Photo]()
    
    public var count: Int {
        return self.photos.count
    }
    
    init(photos: [Photo]){
        self.photos = photos
    }
    
    //get Photo Model
    public func indexPhotoModel(_ index: IndexPath) -> Photo {
        return self.photos[index.row]
    }
    
    //Get image
    func setImage(to url: URL, completionHanlder: @escaping PublishHandler) {
        completionHanlder( AllenRequestCenter.sharedInstance.imagePublisher(for: url, errorImage: UIImage(systemName: "xmark.octagon")))
 
    }
   
}
