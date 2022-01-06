//
//  MainListViewModel.swift
//  Lista
//
//  Created by jonas junior on 29/12/21.
//

import RxCocoa
import RealmSwift

class MainListViewModel {
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var items = PublishRelay<Results<Item>>()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    func fetchProductList() {
        items.accept(todoItems!)
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
      
        fetchProductList()
    }
}
