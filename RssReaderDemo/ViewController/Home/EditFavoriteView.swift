//
//  AddFavoriteView.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/24.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit

class EditFavoriteView: UIView {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    private var mode: FavoriteMode = .NotSelect
    private var edited: Bool = false
    private var actionBlock: (() -> Void)?
    private var originData: MOFavoriteURL?
    
    init(frame: CGRect, mode: FavoriteMode) {
        Debug.println(msg: "init EditView")
        super.init(frame: frame)
        self.mode = mode
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Debug.println(msg: "de EditView")
    }
    
    private func setup() {
        let nib = UINib(nibName: "EditFavoriteView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        backgroundView.frame = bounds
        self.addSubview(backgroundView)
        initView()
    }
    
    private func initView() {
        self.backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.contentView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        self.titleLabel.text = "新增"
        self.nameLabel.text = "名稱"
        self.urlLabel.text = "網址"
        self.nameTextField.placeholder = "請輸入想要的名稱"
        self.nameTextField.borderStyle = .roundedRect
        self.urlTextField.placeholder = "請輸入需要的網址"
        self.urlTextField.borderStyle = .roundedRect
        self.okBtn.setTitle("確認", for: .normal)
        self.cancelBtn.setTitle("取消", for: .normal)
        self.okBtn.setTitleColor(.red, for: .normal)
//        self.cancelBtn.setTitleColor(.red, for: .normal)
        // Add Tap Close GestureRecognizer. 點擊關閉手勢
        let doubleFingers =
          UITapGestureRecognizer(
            target:self,
            action:#selector(self.closeView))
        self.addGestureRecognizer(doubleFingers)
    }
    
    @objc
    private func closeView() {
        if let actionBlock = actionBlock {
            actionBlock()
        }
        self.removeFromSuperview()
        // If not nil, Memory leak. 沒清掉會造成記憶體洩漏
        self.actionBlock = nil
    }
    
    public func setEditData(data: MOFavoriteURL) {
        self.titleLabel.text = "編輯"
        self.originData = data
        self.nameTextField.text = data.name
        self.urlTextField.text = data.url
    }
    // Set Closure.
    public func setActionBlock(action: (() -> Void)?) {
        self.actionBlock = action
    }
    
    public func getIsEdited() -> Bool {
        return self.edited
    }
    
    public func getViewMode() -> FavoriteMode {
        return self.mode
    }
}

// Button Action.
extension EditFavoriteView {
    @IBAction func okBtnAction(_ sender: UIButton) {
        // Add新增資料至db, Edit修改資料存入
        switch mode {
        case .Add:
            if self.dataCheckInfo() != true { return }
            guard let name = self.nameTextField.text else { return }
            guard let url = self.urlTextField.text else { return }
            
            let urlEncoded = url.trimmingCharacters(in: .whitespacesAndNewlines).urlEncoded()
            MOFavoriteURL.createWith(name: name, url: urlEncoded)
            self.edited = true
            
        case .Edit:
            if self.dataCheckInfo() != true { return }
            guard let name = self.nameTextField.text else { return }
            guard let url = self.urlTextField.text else { return }
            
            guard let data = originData else { return }
            let urlEncoded = url.trimmingCharacters(in: .whitespacesAndNewlines).urlEncoded()
            MOFavoriteURL.editWith(data: data, newSeq: data.seq, newName: name, newURL: urlEncoded)
            self.edited = true
            
        default:
            Debug.println(msg: "Default")
        }
        self.closeView()
    }
    
    // 檢查資料可用性及提醒
    private func dataCheckInfo() -> Bool {
        guard let name = self.nameTextField.text else { return false }
        guard let url = self.urlTextField.text else { return false }
        
        switch (name.count, url.count) {
        case (0, 0):
            self.backgroundView.showToast(text: "請輸入名稱及網址")
            return false
        case (0, 1...):
            self.backgroundView.showToast(text: "請輸入名稱")
            return false
        case (1..., 0):
            self.backgroundView.showToast(text: "請輸入網址")
            return false
        case (1..., 1...):
            let url = url.trimmingCharacters(in: .whitespacesAndNewlines).urlEncoded()
            guard let _ = URL(string: url) else {
                self.backgroundView.showToast(text: "網址不能識別 請重新輸入")
                return false
            }
            return true
            
        default:
            self.backgroundView.showToast(text: "網址不能識別 請重新輸入")
            Debug.println(msg: "NOOO")
            return false
        }
    }
    
    // Close Custom View.
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.closeView()
    }
}
