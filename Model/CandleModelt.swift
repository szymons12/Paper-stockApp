//
//  CandleRequest.swift
//  Paper-Stock
//
//  Created by Szymon on 20/10/2026.
//

import Foundation

struct CandleModel: Decodable {
    let symbol: String
    let timeframe: Timeframe
    let o: Double
    let h: Double
    let l: Double
    let c: Double
    let t: Date
}

enum Timeframe: String, Decodable{
    case min1 = "MIN_1"
    case min5 = "MIN_5"
    case min10 = "MIN_10"
    case min15 = "MIN_15"
    case min30 = "MIN_30"
    case hour1 = "HOUR_1"
    case hour4 = "HOUR_4"
    case day1 = "DAY_1"
    case week1 = "WEEK_1"
    case month1 = "MONTH_1"
}
