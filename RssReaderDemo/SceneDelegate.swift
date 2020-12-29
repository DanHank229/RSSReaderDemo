//
//  SceneDelegate.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/11/17.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit
import SideMenuSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window?.windowScene = windowScene
//        window?.rootViewController = HomeVC()
//        window?.makeKeyAndVisible()

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        self.window?.rootViewController = MenuManager.instance.getDrawer()
        self.window?.makeKeyAndVisible()
    }
}

