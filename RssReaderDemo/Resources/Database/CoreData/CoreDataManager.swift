//
//  CoreDataManager.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/22.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    private init() {}
    static let shared = CoreDataManager()

    // 取得 AppDelegate 的 NSManagedObjectContext
    lazy var context: NSManagedObjectContext = {
        let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        return context
    }()
    
    // 更新數據
    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
