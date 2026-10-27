//
//  RegisterRequest.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import Foundation

struct RegisterRequest: Codable {
    let displayName: String
    let email: String
    let password: String
}

