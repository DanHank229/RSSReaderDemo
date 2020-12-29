//
//  SettingVC.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/10.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    init() {
        Debug.println(msg: "init SettingVC")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Debug.println(msg: "de SettingVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = MenuManager.instance.setNavigationMenuBtn()
        self.title = "設定"
        self.titleLabel.text = "空空如也."
    }
}
