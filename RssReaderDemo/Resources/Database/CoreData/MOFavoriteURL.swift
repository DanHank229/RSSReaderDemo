//
//  MOFavorityURL.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/22.
//  Copyright © 2020 9s. All rights reserved.
//

import Foundation
import CoreData

@objc(MOFavoriteURL)
class MOFavoriteURL: NSManagedObject {
    
    @NSManaged var seq: Int64
    @NSManaged var name: String
    @NSManaged var url: String
//    @NSManaged var tags: Int64
}

extension MOFavoriteURL {
    // 儲存改動
    static private func saveContext() {
        do {
            try CoreDataManager.shared.context.save()
        } catch {
            debugPrint("MOFavoriteURL save error.")
        }
    }
    
    /// Get All Favorites(seq sort). 取得所有Favorite.
    static func getAll() -> [MOFavoriteURL] {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<MOFavoriteURL>(entityName: "MOFavoriteURL")
        do {
            let result = try context.fetch(fetchRequest)
            return result.sorted { (l, r) -> Bool in
                return l.seq < r.seq
            }
        } catch {
            debugPrint("MOFavoriteURL getAllFavorites error.")
            return []
        }
    }
    
    /// 新增 Station
    static func createWith(name: String, url: String) {
        let context = CoreDataManager.shared.context
        let _favorite = NSEntityDescription.insertNewObject(forEntityName: "MOFavoriteURL", into: context)
        guard let favorite = _favorite as? MOFavoriteURL else { return }
        let seq = MOFavoriteURL.getAll().count
        
        favorite.name = name
        favorite.url = url
        favorite.seq = Int64(seq)
        
        saveContext()
    }
    
    /// 依照 所給條件查詢刪除
    static func deleteWith(seq: Int64, name: String, url: String) {
        let fetchRequest = NSFetchRequest<MOFavoriteURL>(entityName: "MOFavoriteURL")
        fetchRequest.predicate = NSPredicate(format: "seq == %@ AND name == %@ AND url == %@",
                                             NSNumber(value: seq), name, url)
        do {
            let result = try CoreDataManager.shared.context.fetch(fetchRequest)
            for person in result {
                CoreDataManager.shared.context.delete(person)
            }
        } catch {
            debugPrint("MOFStation deleteWith error.")
        }
        saveContext()
    }
//    static func deleteNewtypeWith(data: MOFavoriteURL) {
//        let fetchRequest = NSFetchRequest<MOFavoriteURL>(entityName: "MOFavoriteURL")
//        fetchRequest.predicate = NSPredicate(format: "seq == % AND name == %@ AND url == %@", data.seq, data.name, data.url)
//        do {
//            let result = try CoreDataManager.shared.context.fetch(fetchRequest)
//            for person in result {
//                CoreDataManager.shared.context.delete(person)
//            }
//        } catch {
//            debugPrint("MOFStation deleteWith error.")
//        }
//        saveContext()
//    }
    
    /// Edit Tag Name and Seq, Edit Name Ues. 根據name與seq修改
    static func editWith(data: MOFavoriteURL, newSeq: Int64, newName: String, newURL: String) {
        let fetchRequest = NSFetchRequest<MOFavoriteURL>(entityName: "MOFavoriteURL")
        fetchRequest.predicate = NSPredicate(format: "seq == %@ AND name == %@ AND url == %@",
                                             NSNumber(value: data.seq), data.name, data.url)
        
        do {
            let result = try CoreDataManager.shared.context.fetch(fetchRequest)
            for tag in result {
                tag.seq = newSeq
                tag.name = newName
                tag.url = newURL
            }
        } catch {
            debugPrint("MOFTags editTagName error.")
        }
        saveContext()
    }
    
    /// Search Favorite. 查詢.
    static func searchFavoriteWith(seq: Int64, name: String, url: String) -> [MOFavoriteURL] {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<MOFavoriteURL>(entityName: "MOFavoriteURL")
        fetchRequest.predicate = NSPredicate(format: "seq == %@ AND name == %@ AND url == %@",
                                             NSNumber(value: seq), name, url)
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            debugPrint("MOFStation getStationWith error.")
            return []
        }
    }
    
    /// Favorite 加入 Tag
//    static func editStationAddTag(xno: String, stationId: String, goBack: Int, tagName: String, seq: Int64) {
//        let tags = MOFavoriteTags.getTagWith(name: tagName, seq: seq)
//
//        let fetchRequest = NSFetchRequest<MOFavoriteStation>(entityName: "MOFavoriteStation")
//
//        let predicateIsXno = NSPredicate(format: "xno == %@", xno)
//        let predicateIsStation = NSPredicate(format: "stationId == %@", stationId)
//        let predicateIsSeq = NSPredicate(format: "direction == %@", NSNumber(value: goBack))
//        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsXno, predicateIsStation, predicateIsSeq])
//
//        fetchRequest.predicate = andPredicate
//
//        do {
//            let _station = try CoreDataManager.shared.context.fetch(fetchRequest)
//            guard let station = _station.first else { return }
//            guard let tag = tags.first else { return }
//
//            station.tags.insert(tag)
//        } catch {
//            debugPrint("MOFStation editStationAddTag error.")
//        }
//        saveContext()
//    }
    
    /// Favorite 刪除 Tag
//    static func deleteStationInTag(xno: String, stationId: String, goBack: Int64, tagName: String, seq: Int64) {
//        let tags = MOFavoriteTags.getTagWith(name: tagName, seq: seq)
//
//        let fetchRequest = NSFetchRequest<MOFavoriteStation>(entityName: "MOFavoriteStation")
//
//        let predicateIsXno = NSPredicate(format: "xno == %@", xno)
//        let predicateIsStation = NSPredicate(format: "stationId == %@", stationId)
//        let predicateIsSeq = NSPredicate(format: "direction == %@", NSNumber(value: goBack))
//        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsXno, predicateIsStation, predicateIsSeq])
//
//        fetchRequest.predicate = andPredicate
//
//        do {
//            let _station = try CoreDataManager.shared.context.fetch(fetchRequest)
//            guard let station = _station.first else { return }
//            guard let tag = tags.first else { return }
//
//            station.tags.remove(tag)
//        } catch {
//            debugPrint("MOFStation deleteStationInTag error.")
//        }
//        saveContext()
//    }
    

}

