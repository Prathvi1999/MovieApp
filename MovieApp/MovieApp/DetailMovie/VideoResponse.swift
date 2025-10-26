//
//  VideoResponse.swift
//  MovieApp
//

//

import Foundation
struct VideoResponse: Codable {
    let id: Int
    let results: [Video]
}

struct Video: Codable, Identifiable {
    let id: String
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let published_at: String
}
