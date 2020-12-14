//
//  Config.swift
//  TB2
//
//  Created by OVO on 08/12/20.
//  Copyright © 2020 yakub. All rights reserved.
//

import Foundation

struct Config: Decodable {
    private enum CodingKeys: String, CodingKey {
        case apiProvince, pathIndonesia, covidDns
    }
    
    let apiProvince: String
    let pathIndonesia: String
    let covidDns: String
}

struct ConfigAccessor{
    
    static func parseConfig() -> Config {
        let url = Bundle.main.url(forResource: "Config", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try! decoder.decode(Config.self, from: data)
    }
    
}

