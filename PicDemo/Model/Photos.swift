//
//  Photos.swift
//  PicDemo
//
//  Created by ko on 2020/9/22.
//  Copyright © 2020 SM. All rights reserved.
//

import Foundation
 

struct Photo: Decodable {
    let albumId: Int?
    let id: Int?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
    
    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        albumId = try keyedContainer.decodeIfPresent(Int.self, forKey: CodingKeys.albumId)
        id = try keyedContainer.decodeIfPresent(Int.self, forKey: CodingKeys.id)
        title =  try keyedContainer.decodeIfPresent(String.self, forKey: CodingKeys.title)
        url =  try keyedContainer.decodeIfPresent(String.self, forKey: CodingKeys.url)
        thumbnailUrl =  try keyedContainer.decodeIfPresent(String.self, forKey: CodingKeys.thumbnailUrl)
    }
 
    enum CodingKeys: String, CodingKey {
        case albumId
        case id
        case title
        case url
        case thumbnailUrl
    }
}

 
