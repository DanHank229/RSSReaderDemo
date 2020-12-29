//
//  SideMenu+Ex.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/17.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit
import SideMenuSwift

class MenuManager {
    
    private var centerVC: UIViewController
    private var drawer: SideMenuController
    
    init() {
        self.centerVC = HomeVC()
        self.drawer = SideMenuController.init(
            contentViewController: UINavigationController(rootViewController: centerVC),
            menuViewController: MenuVC())
//        self.drawer.view.window?.rootViewController?.navigationController?.navigationBar.barTintColor = .red
//        self.drawer.navigationController?.navigationBar.barTintColor = .yellow
//        self.drawer.contentViewController.navigationController?.navigationBar.barTintColor = .yellow
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.size.width * 0.7
        SideMenuController.preferences.basic.position = .under
        SideMenuController.preferences.basic.direction = .left
    }
    
    public static var instance: MenuManager = {
        let menu = MenuManager()
        return menu
    }()
    /// Left Menu Open.
    public func openLeft() {
        self.drawer.revealMenu()
    }
    /// Left Menu Close.
    public func closeLeft() {
        self.drawer.hideMenu()
    }
    
    public func getDrawer() -> SideMenuController {
        return self.drawer
    }
    
    public func setCenterVC(vc: UIViewController) {
        self.centerVC = vc
        self.drawer.contentViewController = UINavigationController(rootViewController: vc)
        self.drawer.hideMenu()
    }
    
    public func setNavigationMenuBtn() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(named:"list")?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(self.check))
    }
    
    @objc
    private func check() {
        Debug.println(msg: "SideMenu Open.")
        self.openLeft()
    }
}
