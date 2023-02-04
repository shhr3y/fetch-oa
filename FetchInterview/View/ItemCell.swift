//
//  ItemCell.swift
//  FetchInterview
//
//  Created by Shrey Gupta on 2/3/23.
//

import UIKit

//protocol ItemCellDelegate: AnyObject {
//    func didTap(onCell cell: ItemCell)
//}

// UI & Logic for ItemCell
class ItemCell: UITableViewCell {
    //MARK: - Properties
    var item: Item? {
        didSet {
            guard let item = item else { return }
            itemLabel.text = item.name
        }
    }
    
//    weak var delegate: ItemCellDelegate?
    
    //MARK: - UI Elements
    let itemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        label.semanticContentAttribute = .spatial
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
//
//        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleTap() {
        // passing onTap callback to assigned delegators
        // self.delegate?.didTap(onCell: self)
    }
    
    //MARK: - Helper Functions
    
    func configureCell() {
        let mainStack = UIStackView(arrangedSubviews: [itemLabel])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 10
        mainStack.semanticContentAttribute = .spatial
        
        self.addSubview(mainStack)
        mainStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 18, paddingRight: 18)
    }
}
