//
//  ViewController.swift
//  Lista
//
//  Created by jonas junior on 29/12/21.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class MainListViewController: CommonViewController {
    internal let viewModel = MainListViewModel()
    private let realm = try! Realm()
    
    lazy var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.loadItems()
        self.navigationItem.title = "Items"
        bindElements()
    }
//    faz algo:
//    self.navigationController?.navigationBar.tintColor = .green
    override func viewWillAppear(_ animated: Bool) {
//        if let colorHex = self.viewModel.selectedCategory?.color {
//            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
//            navBar.backgroundColor = UIColor(hexString: colorHex)
//            navBar.tintColor = UIColor(hexString: colorHex)
//            let appearance = UINavigationBarAppearance()
//            appearance.backgroundColor = UIColor(hexString: colorHex)
//            UINavigationBar.appearance().backgroundColor = .red
        
            UINavigationBar.appearance().tintColor = .green
        UINavigationBar.appearance().barTintColor = .red
        UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().backgroundColor = .purple
        self.navigationController?.navigationBar.barTintColor = .black
        
        self.navigationController?.navigationBar.backgroundColor = .yellow
        
//        }
//        let appearance: UINavigationBarAppearance = {
//            let appearance = UINavigationBarAppearance()
//            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//            appearance.configureWithOpaqueBackground()
//            appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 25),
//                                              .foregroundColor: UIColor.white]
//            appearance.backgroundColor = UIColor(named: K.ColorName.lightBlue)
//            return appearance
//        }()
//
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    override func viewHierarchy() {
        super.viewHierarchy()
        view.addSubview(searchBar)
    }
    
    override func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        
        tableView.snp.remakeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }

    func bindElements() {
  
        viewModel
            .items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell",
                                         cellType: SwipeTableViewCell.self)) { (row, item, cell) in
                
                cell.delegate = self
                cell.textLabel?.font = .systemFont(ofSize: 14)
                cell.textLabel?.text = item.title
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.lineBreakMode = .byWordWrapping
                cell.textLabel?.lineBreakStrategy = .pushOut
                cell.accessoryType = item.done ? .checkmark : .none
                
                if let color = UIColor(hexString: self.viewModel.selectedCategory!.color)?
                    .darken(byPercentage: CGFloat(row) / CGFloat(self.viewModel.todoItems!.count)) {
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                }
            }
            .disposed(by: disposeBag)
            
        
        viewModel.fetchProductList()
        
        tableView.rx.itemSelected
          .subscribe(onNext: { indexPath in
              
              if let item = self.viewModel.todoItems?[indexPath.row] {
                  do {
                      try self.realm.write {
                          item.done = !item.done
                      }
                  } catch {
                      print("Error saving done status, \(error)")
                  }
              }
              
              self.tableView.reloadData()
              
              self.tableView.deselectRow(at: indexPath, animated: true)
          })
          .disposed(by: disposeBag)

        btAdd.rx.tap
            .subscribe(onNext: {
                
                var textField = UITextField()
                
                let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Add Item", style: .default) { action in
                    
                    if let currentCategory = self.viewModel.selectedCategory {
                        do {
                            try self.realm.write {
                                let newItem = Item()
                                newItem.title = textField.text!
                                newItem.dateCreated = Date()
                                currentCategory.items.append(newItem)
                            }
                        } catch {
                            print("Error saving new items, \(error)")
                        }
                    }
                    
                    self.viewModel.loadItems()
                }
                
                alert.addTextField { alertTextField in
                    alertTextField.placeholder = "Create new item"
                    textField = alertTextField
                }
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                let vc = CategoryViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
  
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: {
                print("Opaaaa")
                self.viewModel.todoItems = self.viewModel.todoItems?
                    .filter("title CONTAINS[cd] %@", self.searchBar.text!)
                    .sorted(byKeyPath: "dateCreated", ascending: true)
                
                self.viewModel.fetchProductList()
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .subscribe(onNext: { text in
                print(text!)
                
                if text! == "" {
                    self.viewModel.loadItems()
                    
                    DispatchQueue.main.async {
                        self.searchBar.resignFirstResponder()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.viewModel.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
        self.viewModel.loadItems()
    }
}
