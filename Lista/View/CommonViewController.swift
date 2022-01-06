//
//  CommonViewController.swift
//  Lista
//
//  Created by jonas junior on 04/01/22.
//

import UIKit
import SnapKit
import SwipeCellKit

class CommonViewController: BaseViewController, SwipeTableViewCellDelegate {

    var btAdd: UIBarButtonItem = {
        let img = UIImage(systemName: K.ImageName.add)
        let bbi = UIBarButtonItem(image: img, style: .done, target: nil, action: nil)
        bbi.tintColor = .white
        return bbi
    }()
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 70
        tv.separatorStyle = .none
        tv.register(SwipeTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tv
    }()
    
    override func viewHierarchy() {
        self.navigationItem.rightBarButtonItem = self.btAdd
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.trailing.equalToSuperview()
        }
    }
    
    func updateModel(at indexPath: IndexPath) { }

    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
        }

        deleteAction.image = UIImage(systemName: "trash")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsOptionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        return options
    }
}
