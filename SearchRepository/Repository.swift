//
//  Repository.swift
//  SearchRepository
//
//  Created by 北邑圭佑 on 2019/07/08.
//  Copyright © 2019 北邑圭佑. All rights reserved.
//

import UIKit

class Repository {
    
    var fullName: String
    var description: String
    var stars: Int
    var htmlUrl: String
    
    init(_ fullName: String, _ description: String, _ stars: Int, _ htmlUrl: String) {
        self.fullName = fullName
        self.description = description
        self.stars = stars
        self.htmlUrl = htmlUrl
    }

}
