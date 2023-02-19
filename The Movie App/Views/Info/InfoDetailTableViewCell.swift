//
//  InfoDetailTableViewCell.swift
//  The Movies App
//
//  Created by Hana Salsabila on 18/02/23.
//

import UIKit
import WebKit

class InfoDetailTableViewCell: UITableViewCell {

    static let identifier = "InfoTableViewCell"
    
    var idSelect : Int = 0
    var mediaSelect : String = ""
    var reviewCounts : Int = 0
    
    private var reviews : [Author] = [Author]()
    
    private let webView : WKWebView = {
        let webView = WKWebView()
        webView.contentMode = .center
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(webView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingLabel)
        
        configureConstraints()
    }
    
    func configureConstraints() {
        
        let webViewConstraints = [
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        
        let releaseDateLabelConstraints = [
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            releaseDateLabel.widthAnchor.constraint(equalToConstant: 300)
        ]

        let overviewLabelConstraints = [
            overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        
        let ratingLabelConstraints = [
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.topAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ratingLabel.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(releaseDateLabelConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
    }
    
    func configure(title : String, overview: String, url: String, date: String, rate: Double) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(url)") else {
            return
        }
        webView.load(URLRequest(url: url))
        titleLabel.text = title
        overviewLabel.text = overview
        releaseDateLabel.text = "Release Date: \(date)"
        ratingLabel.text = "Rating: \(rate)/10"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
