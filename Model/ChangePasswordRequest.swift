//
//  ChangePasswordRequest.swift
//  Paper-Stock
//
//  Created by Szymon on 20/08/2026.
//

import Foundation

struct ChangePasswordRequest: Codable {
    let oldPassword: String
    let newPassword: String
}
