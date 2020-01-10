//
//  ImagesModel.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 17.12.2019.
//  Copyright © 2019 Тимофей Забалуев. All rights reserved.
//

import Foundation

struct ImagesModel: Codable {
    let total: Int?
    let total_pages : Int?
    let results : [Results]?

    enum CodingKeys: String, CodingKey {
        case total = "total"
        case total_pages = "total_pages"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }
}

struct Results : Codable {
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
   let categories : [String]?
   let current_user_collections : [String]?

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
       case categories = "categories"
       case current_user_collections = "current_user_collections"
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
       categories = try values.decodeIfPresent([String].self, forKey: .categories)
       current_user_collections = try values.decodeIfPresent([String].self, forKey: .current_user_collections)
   }
}

