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
    var id: Date {t}
}

enum Timeframe: String, Codable, CaseIterable{
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
    
    var seconds: Double {
            switch self {
            case .min1:   return 60
            case .min5:   return 5 * 60
            case .min10:  return 10 * 60
            case .min15:  return 15 * 60
            case .min30:  return 30 * 60
            case .hour1:  return 3600
            case .hour4:  return 4 * 3600
            case .day1:   return 24 * 3600
            case .week1:  return 7 * 24 * 3600
            case .month1: return 30 * 24 * 3600
            }
        }
    var label: String {
        switch self {
        case .min1:   return "1m"
        case .min5:   return "5m"
        case .min10:  return "10m"
        case .min15:  return "15m"
        case .min30:  return "30m"
        case .hour1:  return "1h"
        case .hour4:  return "4h"
        case .day1:   return "1D"
        case .week1:  return "1W"
        case .month1: return "1M"
        }
    }
}
