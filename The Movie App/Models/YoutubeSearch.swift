//
//  YoutubeSearch.swift
//  The Movies App
//
//  Created by Hana Salsabila on 17/02/23.
//

import Foundation

struct YoutubeSearch: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
