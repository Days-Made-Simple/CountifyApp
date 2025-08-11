//
//  CountdownItem.swift
//  countify
//
//  Created by Ye Zonglin Isaac on 2/8/25.
//

import Foundation

struct CountdownItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var date: Date
    var description: String?
    var createdDate: Date
    var isPinned: Bool = false
}
