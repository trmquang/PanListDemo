//
//  Data.swift
//  PanListDemo
//
//  Created by Quang Minh Trinh on 8/31/16.
//  Copyright © 2016 Quang Minh Trinh. All rights reserved.
//

import Foundation

class Data {
    var id: String
    var name: String
    init() {
        id = ""
        name = ""
    }
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}