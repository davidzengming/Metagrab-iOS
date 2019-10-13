//
//  GenrePage.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-09-05.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI

struct GenresPage: Hashable, Codable {
    var previous: String?
    var next: String?
    var results: [Genre]
}
