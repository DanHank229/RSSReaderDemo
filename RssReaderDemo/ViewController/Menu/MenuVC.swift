//
//  MenuVC.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/3.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit
import SideMenuSwift

class MenuVC: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var logoNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let menuData = ["首頁", "設定"]
    
    init() {
        Debug.println(msg: "init MenuVC")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Debug.println(msg: "de MenuVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initSetView()
    }
    
    private func initTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "MenuCell", bundle: nil),
                                forCellReuseIdentifier: "MenuCell")
    }
    
    private func initSetView() {
        self.logoImg.image = #imageLiteral(resourceName: "logo")
    }
}

extension MenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell",for: indexPath)
        let _cell = cell as? MenuCell
        let text = menuData[indexPath.row]
        _cell?.present(text: text)
        return cell
    }
}

extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Debug.println(msg: "Switch VC to index \(indexPath.row)")
        
        self.dismiss(animated: true, completion: nil)
        if indexPath.row == 0 {
            MenuManager.instance.setCenterVC(vc: HomeVC())
        } else if indexPath.row == 1 {
            MenuManager.instance.setCenterVC(vc: SettingVC())
        }
        
        Debug.println(msg: "SideMenu Close.")
    }
}
