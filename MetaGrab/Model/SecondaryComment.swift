//
//  SecondaryComment.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-22.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation

struct SecondaryComment: Hashable, Codable, Identifiable {
    var id: Int
    var content: String
    var upvotes: Int
    var downvotes: Int
    var author: Int
    var parentPost: Int
}
