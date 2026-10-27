//
//  LoginReponse.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import Foundation

struct LoginReponse: Decodable {
    let accessToken: String
    let refreshToken: String
}

