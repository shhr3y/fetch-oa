//
//  ItemCell.swift
//  FetchInterview
//
//  Created by Shrey Gupta on 2/3/23.
//

import UIKit

class ItemCell: UITableViewCell {
    //MARK: - Properties
    var item: Item? {
        didSet {
            guard let item = item else { return }
            itemLabel.text = item.name
        }
    }
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func configureCell() {
        let mainStack = UIStackView(arrangedSubviews: [itemLabel])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 10
        mainStack.semanticContentAttribute = .spatial
        
        addSubview(mainStack)
        mainStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 18, paddingRight: 18)
    }
}
