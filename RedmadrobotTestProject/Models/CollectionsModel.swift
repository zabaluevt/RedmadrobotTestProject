//
//  CollectionsModel.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 09.01.2020.
//  Copyright © 2020 Тимофей Забалуев. All rights reserved.
//

import Foundation

struct CollectionsModel : Codable {
    let id : Int?
    let title : String?
    let description : String?
    let published_at : String?
    let updated_at : String?
    let curated : Bool?
    let featured : Bool?
    let total_photos : Int?
    let cover_photo : Cover_photo?
    let links : Links?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case published_at = "published_at"
        case updated_at = "updated_at"
        case curated = "curated"
        case featured = "featured"
        case total_photos = "total_photos"
        case cover_photo = "cover_photo"
        case links = "links"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        published_at = try values.decodeIfPresent(String.self, forKey: .published_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        curated = try values.decodeIfPresent(Bool.self, forKey: .curated)
        featured = try values.decodeIfPresent(Bool.self, forKey: .featured)
        total_photos = try values.decodeIfPresent(Int.self, forKey: .total_photos)
        cover_photo = try values.decodeIfPresent(Cover_photo.self, forKey: .cover_photo)
        links = try values.decodeIfPresent(Links.self, forKey: .links)
    }

}
