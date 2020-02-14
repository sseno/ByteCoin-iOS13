//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Rohmat Suseno on 13/02/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel: Codable {
    let time: String
    let assetIdBase: String
    let assetIdQuote: String
    let rate: Double
    
    enum CodingKeys: String, CodingKey {
        case time, rate
        case assetIdBase = "asset_id_base"
        case assetIdQuote = "asset_id_quote"
    }
    
    func rateFormatter(rate price: Double) -> String {
        return String(format: "%.2f", price)
    }
}
