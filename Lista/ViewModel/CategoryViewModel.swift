//
//  CategoryViewModel.swift
//  Lista
//
//  Created by jonas junior on 04/01/22.
//

import RxCocoa
import RealmSwift
import Foundation

class CategoryViewModel {
    let realm = try! Realm()
    var categoriesArray: Results<Category>?
    var categories = PublishRelay<Results<Category>>()
    
    func fetchList() {
        categories.accept(categoriesArray!)
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
           print("Error saving context \(error)")
        }
    }
    
    func loadCategories() {
        categoriesArray = realm.objects(Category.self)
        
        fetchList()
    }
}
