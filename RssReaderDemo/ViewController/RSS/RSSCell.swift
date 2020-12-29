//
//  RSSCell.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/11/25.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit

class RSSCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension RSSCell {
    func present(data: RSSData) {
        self.titleLabel.text = data.title
        self.infoLabel.text = data.description
        self.timeLabel.text = data.date
    }
}
