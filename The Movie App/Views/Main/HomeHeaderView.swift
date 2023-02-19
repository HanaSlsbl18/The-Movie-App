//
//  HomeHeaderView.swift
//  The Movies App
//
//  Created by Hana Salsabila on 17/02/23.
//

import UIKit

class HomeHeaderView: UIView {

    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let gradientLayer = CAGradientLayer()
    
    private func addGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        addGradient()
    }
    
    public func configure(with model: TitleVM) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        headerImageView.sd_setImage(with: url, completed: nil)
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
        headerImageView.frame = bounds
        gradientLayer.frame = bounds
    }
    
    required init? (coder: NSCoder) {
        fatalError()
    }

}
