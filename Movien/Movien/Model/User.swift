//
//  User.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 5/31/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int?
    let username: String?
    let name: String?
    let avatar: Avatar
    
    static func decode(jsonData: Data) -> User? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(User.self, from: jsonData)
            return result
        } catch let error {
            print("Failed decoding with error: \(error)")
            return nil
        }
    }
}

struct Avatar: Codable {
    let gravatar: Gravatar?
}

struct Gravatar: Codable {
    let hash: String?
}
