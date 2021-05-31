//
//  Credits.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 4/29/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import Foundation

struct Cast:Codable {
    var cast_id:Int?
    var character:String?
    var credit_id:String?
    var name:String?
    var profile_path:String?
    var id:Int?
    
}
struct Crew:Codable {
    var credit_id:String?
    var name:String?
    var department:String?
    var job:String?
    var id:Int?
    var profile_path:String?
    
}

struct Credits:Codable {
    var id: Int?
    var cast:[Cast]?
    var crew:[Crew]?
}
