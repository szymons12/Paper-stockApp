//
//  WhoAmIRequest.swift
//  Paper-Stock
//
//  Created by Szymon on 11/08/2026.
//

import Foundation

struct WhoAmIResponse: Decodable {
    let id: String
    let displayName: String
}
