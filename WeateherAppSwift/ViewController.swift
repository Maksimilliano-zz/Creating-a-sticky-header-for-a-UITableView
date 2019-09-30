//
//  ViewController.swift
//  WeateherAppSwift
//
//  Created by Максим Чижавко on 30/09/2019.
//  Copyright © 2019 Максим Чижавко. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
  
    

    
    var tableView:UITableView!
    var headerView:CustomHeaderView!
    var headerHeightConstraint:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        

        view.backgroundColor = .white
        setUpHeader()
        setUpTableView()
        
        
        
        
        
    }
    
    func setUpHeader() {
        headerView = CustomHeaderView(frame: CGRect.zero , title: "Articles")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 150)
        headerHeightConstraint.isActive = true
        
        let constraints:[NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setUpTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let constraints:[NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    func animateHeader() {
        self.headerHeightConstraint.constant = 150
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    

}












extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
            headerView.incrementColorAlpha(offset: self.headerHeightConstraint.constant)
            headerView.incrementArticleAlpha(offset: self.headerHeightConstraint.constant)
        } else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint.constant >= 65 {
            self.headerHeightConstraint.constant -= scrollView.contentOffset.y/100
            headerView.decrementColorAlpha(offset: scrollView.contentOffset.y)
            headerView.decrementArticleAlpha(offset: self.headerHeightConstraint.constant)
            
            if self.headerHeightConstraint.constant < 65 {
                self.headerHeightConstraint.constant = 65
            }
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > 150 {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > 150 {
            animateHeader()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",   for: indexPath as IndexPath)
        cell.textLabel?.text = "Article \(indexPath.row)"
        return cell
    }
    
    
}
