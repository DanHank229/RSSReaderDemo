//
//  MenuCell.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/11.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MenuCell {
    func present(text: String) {
        self.titleLabel.text = text
    }
}
