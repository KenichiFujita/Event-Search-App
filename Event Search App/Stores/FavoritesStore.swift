//
//  FavoritesStore.swift
//  Event Search App
//
//  Created by Kenichi Fujita on 2/12/21.
//

import Foundation

final class FavoritesStore {

    let key = "favorites"

    let userDefaults: UserDefaults

    var ids: [Int] = []

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        ids = userDefaults.array(forKey: key) as? [Int] ?? []
    }

    func add(id: Int) {
        ids.insert(id, at: 0)
        save()
    }

    func remove(id: Int) {
        if let index = ids.firstIndex(of: id) {
            ids.remove(at: index)
            save()
        }
    }

    func has(id: Int) -> Bool {
        return ids.contains(id)
    }

    private func save() {
        userDefaults.setValue(ids, forKey: key)
    }
    
}
