//
//  InfoDetailsVC.swift
//  The Movies App
//
//  Created by Hana Salsabila on 17/02/23.
//

import UIKit

class InfoDetailsVC: UIViewController {
    
    var idSelect : Int = 0
    var mediaSelect : String = ""
    var titleInfo = ""
    var overviewInfo = ""
    var urlInfo = ""
    var releaseDate = ""
    var voteRating = 0.0
    
    let headerName = "Review"
    
    private var reviews : [Author] = [Author]()

    var tableView : UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(InfoDetailTableViewCell.self, forCellReuseIdentifier: InfoDetailTableViewCell.identifier)
        tv.register(InfoReviewTableViewCell.self, forCellReuseIdentifier: InfoReviewTableViewCell.identifier)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchReviewMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configure(with model: TitleInfoVM) {
        idSelect = model.id
        mediaSelect = model.media
        titleInfo = model.title
        overviewInfo = model.titleOverview
        urlInfo = model.youtubeView.id.videoId
        releaseDate = model.releaseData
        voteRating = model.voteRating
        
    }
    
    private func fetchReviewMovies() {
        ApiCaller.shared.getReview(id: idSelect, media: mediaSelect) { [weak self] results in
            switch results {
            case .success(let reviews):
                self?.reviews = reviews
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension InfoDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return reviews.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoDetailTableViewCell.identifier, for: indexPath) as? InfoDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: titleInfo, overview: overviewInfo, url: urlInfo, date: releaseDate, rate: voteRating)
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoReviewTableViewCell.identifier, for: indexPath) as? InfoReviewTableViewCell else {
                return UITableViewCell()
            }
            let review = reviews[indexPath.row]
            cell.configure(name: review.author, content: review.content, rating: review.authorDetails.rating ?? 0)
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 600
        } else {
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizedFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return headerName
        }
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
