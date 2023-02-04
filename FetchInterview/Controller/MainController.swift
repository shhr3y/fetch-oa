//
//  ViewController.swift
//  FetchInterview
//
//  Created by Shrey Gupta on 2/3/23.
//

import UIKit

class MainController: UIViewController {
    // MARK: - Properties
    // storing all fetched list items
    var allLists = [List]() {
        didSet {
            // sorting list items based on their id
            allLists = allLists.sorted { $0.id < $1.id }
            
            // shifting to main thread before updating UI
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // tableView for displaying all fetched item, initialised in init
    var tableView: UITableView!
    
    
    // MARK: - Init
    init() {
        // tableView init
        self.tableView = UITableView(frame: .zero, style: .grouped)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // calling Service class singleton variable to API call
        Service.shared.fetchList { [weak self] status, list in
            // checking if API call was successful or not
            if status {
                guard let list = list else { return }
                self?.allLists = list
            } else {
                print("DEBUG:- Fetch Failed!")
            }
        }
        
        // setting tableView properties
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        // registering tableView cell 'ItemCell' for reuse
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseIdentifier)
        
        
        // adding tableView in main view's subview
        self.view.addSubview(tableView)
        
        // fill parent view with tableview (implementation in Extensions.swift)
        tableView.fillSuperview()
    }
    
    
    // MARK: - Selectors
    
    
    
    // MARK: - Helper Functions
}

// MARK: - Delegate UITableViewDelegate
extension MainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // simple alert popup displaying basic info when any cell is selected
        let alert = UIAlertController(title: "", message: "You have selected Item \(allLists[indexPath.section].items[indexPath.row].id) from Category \(allLists[indexPath.section].id)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(alert, animated: true)
        
        // unselecting the cell once it is tapped
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}


// MARK: - Delegate UITableViewDataSource
extension MainController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return allLists.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = allLists[section]
        
        // creating simple UI for section
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
    
    // remove footerView to remove padding after each section
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    // setting height of tableView section to 20 (hardcoded)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    // setting height of tableView section to 0
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLists[section].items.count
    }
    
    // setting height of tableView row to 40 (hardcoded)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier) as! ItemCell
        cell.item = self.allLists[indexPath.section].items[indexPath.row]
        return cell
    }
}
