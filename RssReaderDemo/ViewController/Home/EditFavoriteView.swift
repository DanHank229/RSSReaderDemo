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
        self.contentView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
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
            guard let name = self.nameTextField.text else { return }
            guard let url = self.urlTextField.text else { return }
            if name.count == 0 || url.count == 0 {
                return
            }
            MOFavoriteURL.createWith(name: name, url: url)
            self.edited = true
            
        case .Edit:
            guard let name = self.nameTextField.text else { return }
            guard let url = self.urlTextField.text else { return }
            if name.count == 0 || url.count == 0 {
                return
            }
            guard let data = originData else { return }
            MOFavoriteURL.editWith(data: data, newSeq: data.seq, newName: name, newURL: url)
            self.edited = true
            
        default:
            Debug.println(msg: "Default")
        }
        self.closeView()
    }
    
    // Close Custom View.
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.closeView()
    }
}

enum FavoriteMode {
    case Add
    case Edit
    case Delete
    case NotSelect
}
