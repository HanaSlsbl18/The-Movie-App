//
//  SearchResultsVC.swift
//  The Movies App
//
//  Created by Hana Salsabila on 17/02/23.
//

import UIKit

protocol SearchResultsVCDelegate: AnyObject {
    func searchResultsVCDidTapItem(_ viewModel: TitleInfoVM)
}

class SearchResultsVC: UIViewController {
    
    public var titles : [Title] = [Title]()
    
    public weak var delegate: SearchResultsVCDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
    
}

extension SearchResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        
        return cell
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
                self?.delegate?.searchResultsVCDidTapItem(TitleInfoVM(id: title.id, title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? "", media: title.media_type ?? "", releaseData: title.release_date ?? "", voteRating: title.vote_average))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
