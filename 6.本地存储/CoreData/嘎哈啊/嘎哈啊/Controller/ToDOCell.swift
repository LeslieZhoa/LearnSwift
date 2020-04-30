//
//  ToDOCell.swift
//  嘎哈啊
//
//  Created by Leslie Zhao on 2020/4/22.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//

import UIKit

class ToDOCell: UITableViewCell {

    @IBOutlet weak var checkMark: UILabel!
    @IBOutlet weak var todo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
