//
//  ViewController.swift
//  FetchInterview
//
//  Created by Shrey Gupta on 2/3/23.
//

import UIKit

class MainController: UIViewController {
    // MARK: - Properties
    var allLists = [List]() {
        didSet {
            allLists = allLists.sorted { $0.id < $1.id }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var tableView: UITableView!
    
    
    // MARK: - Init
    init() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.shared.fetchList { [weak self] status, list in
            if status {
                guard let list = list else { return }
                self?.allLists = list
            } else {
                print("DEBUG:- Fetch Failed!")
            }
        }
        
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseIdentifier)
        
//        tableView.sectionHeaderTopPadding = 0
        
        self.view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    
    // MARK: - Selectors
    
    
    
    // MARK: - Helper Functions
}

extension MainController: UITableViewDelegate {
    
}

extension MainController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return allLists.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = allLists[section]
        
        let customView = UIView()
        customView.backgroundColor = .lightGray
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = section.id.description
        label.textColor = .white
        
        customView.addSubview(label)
        label.anchor(left: customView.leftAnchor, paddingLeft: 18)
        
        label.centerY(inView: customView)
        
        return customView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLists[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier) as! ItemCell
        cell.item = self.allLists[indexPath.section].items[indexPath.row]
        return cell
    }
}
