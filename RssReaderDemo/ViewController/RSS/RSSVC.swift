//
//  RSSVC.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/11/24.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit
import SafariServices

class RSSVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let url: URL
    private var allData: [RSSData] = []
    private var tagName: String = ""
    private var dataAvailable: Bool = false
    private var data: RSSData?
    
    init(url: URL) {
        Debug.println(msg: "init RSSVC")
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Debug.println(msg: "de RSSVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewInit()
        getRSSInformation()
    }
    
    private func tableViewInit() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "RSSCell", bundle: nil),
                                forCellReuseIdentifier: "RSSCell")
    }
    
    /// 取得RSS內的資訊. Get RSS Info.
    private func getRSSInformation() {
        if let xml = XMLParser(contentsOf: url) {
            xml.delegate = self
            // 開始解析
            xml.parse()
        }
        // no data not work.
        if self.allData.count != 0 {
            self.tableView.reloadData()
        } else {
            Debug.println(msg: "No Data.")
        }
    }
}

// RSS Decode. RSS解析
extension RSSVC: XMLParserDelegate {
    // 碰到開始標籤時
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        // 當 elementName 是 "item" 時, 開始解析.
        if elementName == "item"{
            // 新增一個新物件
            data = RSSData(title: "", description: "", link: "", date: "", imageLink: "")
            dataAvailable = true
        }
        // 資料可用時設定tagName標示
        if dataAvailable == true {
            tagName = elementName
        } else {
            tagName = ""
        }
    }
     
    // 碰到標籤內字串時
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        // 設定 title 用
        if self.title == nil || self.title == "" {
            setTitle(text: data)
        }
        
        // 每碰到一個字串 將字串加入相對應的位置
        switch tagName {
        case "title":
            self.data?.title = data
        case "description":
            self.data?.description = data
        case "link":
            self.data?.link = data
        case "pubDate":
            self.data?.date = data
        case "enclosure":
            self.data?.imageLink = data
        default:
            break
        }
    }
     
    // 碰到結束標籤時
    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        
        //標籤文字"item" 讀到時將該data內容存入Array.
        if elementName == "item" {
            guard let data = self.data else { return }
            allData.append(data)
            tagName = ""
            dataAvailable = false
        }
    }
    
    private func setTitle(text: String) {
        self.title = text
    }
}

extension RSSVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSCell",for: indexPath)
        let _cell = cell as? RSSCell
        let data = allData[indexPath.row]
        _cell?.present(data: data)
        return cell
    }
}
// TableView
extension RSSVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = self.allData[indexPath.row].link
        guard let url = URL(string: urlString) else { return }
        
        // 啟動內建safari方案
//        useSFSafaruVC(url: url)
        
        // push.
        usePushPage(url: url)
    }
    
    private func usePushPage(url: URL) {
        let webVC = WebVC(url: url)
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func usePresentPage(url: URL) {
        let webVC = WebVC(url: url)
        self.present(webVC, animated: true) {
        }
    }
}

extension RSSVC: SFSafariViewControllerDelegate {
    private func useSFSafaruVC(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = .black
        safariVC.preferredControlTintColor = .white
        safariVC.dismissButtonStyle = .close
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
}

struct RSSData {
    var title: String
    var description: String
    var link: String
    var date: String
    var imageLink: String
}

/*
"https://gnn.gamer.com.tw/rss.xml"
"https://public.twreporter.org/rss/twreporter-rss.xml"
 https://dq.yam.com/
*/
