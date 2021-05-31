//
//  PeopleCredits.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 4/29/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import Foundation

struct CastData:Codable {
    var poster_path:String?
    var id:Int?
}

struct CrewData:Codable {
    var poster_path:String?
    var id:Int?
}

struct PeopleCredits:Codable {
    var id: Int?
    var cast:[CastData]?
    var crew:[CrewData]?
}
