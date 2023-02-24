//
//  ScrollingCollectionTableViewCell.swift
//  The Movie App
//
//  Created by Hana Salsabila on 23/02/23.
//

import UIKit

protocol ScrollingCollectionTableViewCellDelegate: AnyObject {
    func scrollingCollectionTableViewCellDidTapCell(_ cell: ScrollingCollectionTableViewCell, viewModel: TitleInfoVM)
}

class ScrollingCollectionTableViewCell: UITableViewCell {
    
    static let identifier = "ScrollingCollectionTableViewCell"

    weak var delegate: ScrollingCollectionTableViewCellDelegate?
    
    private var titles : [Title] = [Title]()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    override func willTransition(to state: UITableViewCell.StateMask) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func didTransition(to state: UITableViewCell.StateMask) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ScrollingCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        ApiCaller.shared.getTrailer(with: "\(titleName) trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    guard let titleMedia = title.media_type ?? Optional("") else {
                        return
                    }
                    guard let strongSelf = self else {
                        return
                    }
                    let viewModel = TitleInfoVM(id: title.id, title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? "", media: titleMedia, releaseData: title.release_date ?? "", voteRating: title.vote_average)
                    self?.delegate?.scrollingCollectionTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

extension ScrollingCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isPortrait {
            return CGSize(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4/7*10)
        } else if UIDevice.current.orientation.isLandscape {
            return CGSize(width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6/7*10)
        } else {
            return CGSize(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4/7*10)
        }
    }
}
