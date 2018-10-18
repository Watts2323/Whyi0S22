//
//  Post.swift
//  WhyiOS22
//
//  Created by Xavier on 10/17/18.
//  Copyright © 2018 Xavier ios dev. All rights reserved.
//

import Foundation

struct Post: Codable {
    let name: String
    let reason: String
    let cohort: String = "iOS22"
}
