//
//  MovieResults.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 4/29/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import Foundation

struct MovieResults: Codable {
    
    var region: String?
    var results: [Movie]?
    var total_pages: Int?
    var total_results: Int?
    
    static func decode(jsonData: Data) -> MovieResults? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(MovieResults.self, from: jsonData)
            return result
        } catch let error {
            print("Failed decoding with error: \(error)")
            return nil
        }
    }
}
