//
//  BaseViewController.swift
//  Lista
//
//  Created by jonas junior on 29/12/21.
//

import Foundation
import RxSwift

class BaseViewController: UIViewController, ViewCodeProtocol {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        viewHierarchy()
        setupConstraints()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func viewHierarchy() { }
    
    func setupConstraints() { }
}
