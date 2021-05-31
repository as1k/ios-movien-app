//
//  Constants.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 4/29/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import Foundation

var posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "w1280", "original"]
var trailerQualitySettings: [String] = []
var person_id: Int?

struct Api {
    static let BASE_URL = "https://api.themoviedb.org/3"
    static let KEY = "f37d802a2e69e08c7b337398653c592e"
    static let SESSION_ID = "5799c99999166d35345f8d60bd0ee4984ada3ce1"
    static let ACCOUNT_ID = 9271858
    static let SCHEME = "https"
    static let HOST = "api.themoviedb.org"
    static let PATH = "/3"
    
    static let youtubeThumb = "https://img.youtube.com/vi/"
    static let youtubeLink = "https://www.youtube.com/watch?v="
}

struct ParameterKeys {
    static let API_KEY = "api_key"
    static let PAGE = "page"
    static let TOTAL_RESULTS = "total_results"
    static let REGION = "region"
    static let MOVIE_ID = "movie_id"
    static let KNOWN_FOR = "known_for"
}

struct ImageKeys {
    static let IMAGE_BASE_URL = "https://image.tmdb.org/t/p/"
    
    struct PosterSizes {
        static let BACK_DROP = posterSizes[6]
        static let ROW_POSTER = posterSizes[2]
        static let DETAIL_POSTER = posterSizes[3]
        static let ORIGINAL_POSTER = posterSizes[6]
    }
}

struct Methods {
    static let NOW_PLAYING = "/movie/now_playing"
    static let TRENDING_WEEK = "/trending/movie/week"
    static let UPCOMING = "/movie/upcoming"
    static let TOP_RATED = "/movie/top_rated"
    static let POPULAR_ACTORS = "/person/popular"
    static let TRENDING_TV = "/trending/tv/week"
}
