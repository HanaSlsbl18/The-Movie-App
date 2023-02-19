//
//  InfoReviewTableViewCell.swift
//  The Movies App
//
//  Created by Hana Salsabila on 18/02/23.
//

import UIKit

class InfoReviewTableViewCell: UITableViewCell {
    
    static let identifier = "InfoReviewTableViewCell"
    
    private var reviews : [Author] = [Author]()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(ratingLabel)
        
        configureContraints()
    }
    
    private func configureContraints() {
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let ratingLabelConstraints = [
            ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            ratingLabel.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let contentLabelConstraints = [
            contentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
        NSLayoutConstraint.activate(contentLabelConstraints)
    }
    
    func configure(name: String, content: String, rating: Int) {
        nameLabel.text = name
        contentLabel.text = content
        if rating == 0 {
            ratingLabel.text = "-/10"
        } else {
            ratingLabel.text = "\(rating)/10"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

