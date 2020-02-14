//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didSuccess(_ coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coinModel = self.parseJSON(safeData) {
                        self.delegate?.didSuccess(coinModel)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ coinData: Data) -> CoinModel? {
        do {
            let decodeData = try JSONDecoder().decode(CoinModel.self, from: coinData)
            let obj = CoinModel(time: decodeData.time, assetIdBase: decodeData.assetIdBase, assetIdQuote: decodeData.assetIdQuote, rate: decodeData.rate)
            return obj
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
