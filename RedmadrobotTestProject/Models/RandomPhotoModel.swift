//
//  RandomPhotoModel.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 08.01.2020.
//  Copyright © 2020 Тимофей Забалуев. All rights reserved.
//

import Foundation
struct RandomPhotoModel : Codable {
    let id : String?
    let created_at : String?
    let updated_at : String?
    let promoted_at : String?
    let width : Int?
    let height : Int?
    let color : String?
    let description : String?
    let alt_description : String?
    let urls : Urls?
//    let links : Links?
    let categories : [String]?
    let likes : Int?
    let liked_by_user : Bool?
    let current_user_collections : [String]?
//    let user : User?
//    let exif : Exif?
//    let location : Location?
    let views : Int?
    let downloads : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case promoted_at = "promoted_at"
        case width = "width"
        case height = "height"
        case color = "color"
        case description = "description"
        case alt_description = "alt_description"
        case urls = "urls"
//        case links = "links"
        case categories = "categories"
        case likes = "likes"
        case liked_by_user = "liked_by_user"
        case current_user_collections = "current_user_collections"
//        case user = "user"
//        case exif = "exif"
//        case location = "location"
        case views = "views"
        case downloads = "downloads"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        promoted_at = try values.decodeIfPresent(String.self, forKey: .promoted_at)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        alt_description = try values.decodeIfPresent(String.self, forKey: .alt_description)
        urls = try values.decodeIfPresent(Urls.self, forKey: .urls)
//        links = try values.decodeIfPresent(Links.self, forKey: .links)
        categories = try values.decodeIfPresent([String].self, forKey: .categories)
        likes = try values.decodeIfPresent(Int.self, forKey: .likes)
        liked_by_user = try values.decodeIfPresent(Bool.self, forKey: .liked_by_user)
        current_user_collections = try values.decodeIfPresent([String].self, forKey: .current_user_collections)
//        user = try values.decodeIfPresent(User.self, forKey: .user)
//        exif = try values.decodeIfPresent(Exif.self, forKey: .exif)
//        location = try values.decodeIfPresent(Location.self, forKey: .location)
        views = try values.decodeIfPresent(Int.self, forKey: .views)
        downloads = try values.decodeIfPresent(Int.self, forKey: .downloads)
    }

}
