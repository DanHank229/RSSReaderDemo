//
//  HomeCell.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/24.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    private var data: MOFavoriteURL?
    private var mode: FavoriteMode = .NotSelect
    private var indexPath: IndexPath?
    
    weak var delegate: TableViewCellActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.selectionStyle = .default
        self.editBtn.tintColor = .black
        self.editBtn.setTitle("編輯", for: .normal)
        self.deleteBtn.tintColor = .red
        self.deleteBtn.setTitle("刪除", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func getActionMode() -> FavoriteMode {
        return self.mode
    }
}

extension HomeCell {
    @IBAction func btnEditAction(_ sender: UIButton) {
        self.mode = .Edit
        guard let indexPath = self.indexPath else { return }
        self.delegate?.edit(indexPath)
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        self.mode = .Add
        guard let indexPath = self.indexPath else { return }
        self.delegate?.delete(indexPath)
    }
}

extension HomeCell {
    func present(data: MOFavoriteURL, isEdit: Bool, indexPath: IndexPath) {
        self.data = data
        self.titleLabel.text = data.name
        self.indexPath = indexPath
        
        self.editBtn.isHidden = !isEdit
        self.deleteBtn.isHidden = !isEdit
    }
}
