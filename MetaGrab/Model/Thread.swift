//
//  Thread.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI

struct Thread: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var content: String
    var upvotes: Int
    var downvotes: Int
    var flair: String
    var author: Int
    var forum: Forum
    var numComments: Int
}
