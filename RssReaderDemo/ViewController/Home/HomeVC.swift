//
//  HomeVC.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/2.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit
import SideMenuSwift

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteData: [MOFavoriteURL] = []
    
    init() {
        Debug.println(msg: "init HomeVC")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Debug.println(msg: "de HomeVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "RSS Reader"
        self.initTableView()
        self.setNavigationBar()
        // 網路連線檢查?
    }
    
    private func initTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "HomeCell", bundle: nil),
                                forCellReuseIdentifier: "HomeCell")
        // Search DB Data.
        self.favoriteData = MOFavoriteURL.getAll()
    }
    
    private func setNavigationBar() {
        // add navigation btn and setting.
        self.navigationItem.rightBarButtonItems = self.setNavigationAddFavoriteBtn()
        self.navigationItem.leftBarButtonItem = MenuManager.instance.setNavigationMenuBtn()
    }
    
    //  Set Navegation Button Add, Edit. 導覽 新增 編輯按鈕.
    private func setNavigationAddFavoriteBtn() -> [UIBarButtonItem] {
        let add = UIBarButtonItem(
            image: UIImage(named:"add")?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(self.showAddView))
        let edit = UIBarButtonItem(
            image: UIImage(named:"edit")?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(self.switchEditMode))
        return [edit, add]
    }
    
    @objc
    private func showAddView() {
        // 開啟add(新增)輸入畫面
        self.showCustomView(mode: .Add)
        // 新增時如果還在編輯模式, 切至關閉
        if self.tableView.isEditing == true {
            switchEditMode()
        }
    }
    
    @objc
    private func switchEditMode() {
        // 開關編輯模式
        self.tableView.isEditing = !self.tableView.isEditing
        self.tableView.reloadData()
    }
}

// Cell Delegate.
extension HomeVC: TableViewCellActionDelegate {
    // Cell內按鈕按下後執行對應Func
    func edit(_ indexPath: IndexPath) {
        self.showCustomView(mode: .Edit, indexPath: indexPath)
    }
    
    func delete(_ indexPath: IndexPath) {
        self.showCustomView(mode: .Delete, indexPath: indexPath)
    }
}

// DataSource and Delegate.
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.favoriteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell",for: indexPath)
        let _cell = cell as? HomeCell
        let data = favoriteData[indexPath.row]
        _cell?.delegate = self
        _cell?.present(data: data, isEdit: self.tableView.isEditing, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let data = self.favoriteData[indexPath.row]
        self.selectReaderMode(link: data.url)
    }
}

// Fnuc
extension HomeVC {
    // 選擇閱讀器模式
    private func selectReaderMode(link: String) {
        let isRSSLink: Bool = link.contains("rss") && link.contains("xml")
        // 刪除前後空白並Encoded.
        let _url = link.urlEncoded()
        
        guard let url: URL = URL(string: _url) else {
            Debug.println(msg: "Warring!\nIt's URL String not Valid.")
            return
        }
        
        if url.host == nil {
            Debug.println(msg: "HomeVC url.host is nil.")
            return
        }
        
        if isRSSLink == true {
            self.pushVC(vc: RSSVC(url: url))
            Debug.println(msg: "is RSS")
        } else {
            self.pushVC(vc: WebVC(url: url))
            Debug.println(msg: "is Web")
        }
    }
    
    private func pushVC(vc: UIViewController) {
        Debug.println(msg: "Link Start.")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Add, Delete, Edit Custom View. 選擇自訂通用View功能.
    private func showCustomView(mode: FavoriteMode, indexPath: IndexPath? = nil) {
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        switch mode {
        case .Add:
            let view = EditFavoriteView(frame: frame, mode: .Add)
            let action = {
                let edited = view.getIsEdited()
                let mode = view.getViewMode()
                
                if edited == true && mode == .Add {
                    self.favoriteData = MOFavoriteURL.getAll()
                    self.tableView.reloadData()
                }
            }
            view.setActionBlock(action: action)
            
            UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(view)
            
        case .Edit:
            let view = EditFavoriteView(frame: frame, mode: .Edit)
            let action = {
                let edited = view.getIsEdited()
                let mode = view.getViewMode()
                
                if edited == true && mode == .Edit {
                    self.favoriteData = MOFavoriteURL.getAll()
                    self.tableView.reloadData()
                }
            }
            guard let index = indexPath else { return }
            let data = self.favoriteData[index.row]
            view.setEditData(data: data)
            view.setActionBlock(action: action)
            
            UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(view)
            
        case .Delete:
            guard let index = indexPath else { return }
            let data = self.favoriteData[index.row]
            
            let controller = UIAlertController(title: "刪除動作", message: "是否刪除 \(data.name) 的資料 ?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .destructive) { (_) in
                MOFavoriteURL.deleteWith(seq: data.seq, name: data.name, url: data.url)
                self.favoriteData = MOFavoriteURL.getAll()
                self.tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
            
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
            
        default:
            Debug.println(msg: "Switch Custom View Type default.")
        }
    }
}

extension HomeVC {
    // 移除編輯模式左方圖示
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    // 移除左方縮排
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

protocol TableViewCellActionDelegate: AnyObject {
    func edit(_ indexPath: IndexPath)
    func delete(_ indexPath: IndexPath)
}
