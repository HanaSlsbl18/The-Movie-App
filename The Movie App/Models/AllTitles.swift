//
//  AllTitles.swift
//  The Movies App
//
//  Created by Hana Salsabila on 16/02/23.
//

import Foundation

struct AllTitles: Codable {
    let page: Int
    let results: [Title]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}
