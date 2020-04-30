//
//  Todo.swift
//  嘎哈啊
//
//  Created by Leslie Zhao on 2020/4/30.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var name = ""
    @objc dynamic var checked = false
    @objc dynamic var createAT = Date()
}
