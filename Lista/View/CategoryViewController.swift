//
//  CategoryViewController.swift
//  Lista
//
//  Created by jonas junior on 04/01/22.
//

import RealmSwift
import SwipeCellKit
import ChameleonFramework
import UIKit

class CategoryViewController: CommonViewController {
    private let viewModel = CategoryViewModel()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.loadCategories()
        self.navigationItem.title = "Todo List"
        bindElements()
    }
    
    func bindElements() {
        
        viewModel
            .categories
            .bind(to: tableView.rx.items(cellIdentifier: "Cell",
                                         cellType: SwipeTableViewCell.self)) { (row, item, cell) in

                cell.delegate = self
                cell.textLabel?.font = .systemFont(ofSize: 14)
                cell.textLabel?.text = item.name
                cell.backgroundColor = UIColor(hexString: self.viewModel.categoriesArray?[row].color ?? "FFFFFF")
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.lineBreakMode = .byWordWrapping
                cell.textLabel?.lineBreakStrategy = .pushOut
            }
            .disposed(by: disposeBag)
        
        
        viewModel.fetchList()
        
        tableView.rx.itemSelected
          .subscribe(onNext: { indexPath in
              
              let vc = MainListViewController()
              
              vc.viewModel.selectedCategory = self.viewModel.categoriesArray?[indexPath.row]
              
              self.navigationController?.pushViewController(vc, animated: true)
              
              self.tableView.deselectRow(at: indexPath, animated: true)
          })
          .disposed(by: disposeBag)

        btAdd.rx.tap
            .subscribe(onNext: {
                
                var textField = UITextField()
                
                let alert = UIAlertController(title: "Add New ToDo Category", message: "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Add Category", style: .default) { action in
                    
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    newCategory.color = UIColor.randomFlat().hexValue()
                       
                    self.viewModel.save(category: newCategory)

                    self.viewModel.fetchList()
                }
                
                alert.addTextField { alertTextField in
                    alertTextField.placeholder = "Create new category"
                    textField = alertTextField
                }
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                let vc = CategoryViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.viewModel.categoriesArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
        self.viewModel.loadCategories()
    }
}
