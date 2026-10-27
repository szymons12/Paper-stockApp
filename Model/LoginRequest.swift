//
//  LoginRequest.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}
struct RefreshRequest: Codable {
    let refreshToken: String
}
